// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {Bootstrap} from "test/utils/Bootstrap.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";
import {ZapExposed} from "test/utils/exposed/ZapExposed.sol";
import {ISpotMarketProxy} from "./../src/interfaces/ISpotMarketProxy.sol";

contract ZapTest is Bootstrap {
    IERC20 internal SUSD;
    IERC20 internal USDC;

    // 1_000 $USDC == 1_000_000_000_000_000 $sUSDC/$sUSD
    // or
    // 1 $USDC == 1_000_000_000_000 $sUSDC/$sUSD
    // or
    // 1 $sUSDC == 1e12 $USDC/$sUSD
    uint256 converted_UINT_AMOUNT = UINT_AMOUNT * 1e12;

    function setUp() public {
        vm.rollFork(BASE_BLOCK_NUMBER);
        initializeBase();

        SUSD = IERC20(ZapExposed(address(zap)).expose_SUSD());
        USDC = IERC20(ZapExposed(address(zap)).expose_USDC());

        deal(address(SUSD), ACTOR, INITIAL_MINT);
        deal(address(USDC), ACTOR, INITIAL_MINT);
    }

    function test_deploy() public view {
        assert(address(zap) != address(0));
    }

    function test_usdc_zero_address() public {
        vm.expectRevert();

        new ZapExposed({
            _usdc: address(0),
            _susd: address(0x1),
            _spotMarketProxy: address(0x1),
            _sUSDCId: type(uint128).max
        });
    }

    function test_susd_zero_address() public {
        vm.expectRevert();

        new ZapExposed({
            _usdc: address(0x1),
            _susd: address(0),
            _spotMarketProxy: address(0x1),
            _sUSDCId: type(uint128).max
        });
    }

    function test_spotMarketProxy_zero_address() public {
        vm.expectRevert();

        new ZapExposed({
            _usdc: address(0x1),
            _susd: address(0x1),
            _spotMarketProxy: address(0),
            _sUSDCId: type(uint128).max
        });
    }

    function test_sUSDCId_invalid() public {
        vm.expectRevert();

        new ZapExposed({
            _usdc: address(0x1),
            _susd: address(0x1),
            _spotMarketProxy: address(0x1),
            _sUSDCId: type(uint128).max
        });
    }
}

contract ZapIn is ZapTest {
    function test_zap_in() public {
        vm.startPrank(ACTOR);

        USDC.approve(address(zap), UINT_AMOUNT);

        zap.zap(INT_AMOUNT, REFERRER);

        assertEq(SUSD.balanceOf(address(zap)), UINT_AMOUNT);

        vm.stopPrank();
    }

    function test_zap_in_exceeds_cap() public {
        /// @dev test assumes the wrapper cap is always < 2^255 - 1 (max int128)
        uint256 cap = type(uint128).max;

        vm.startPrank(ACTOR);

        USDC.approve(address(zap), cap);

        try zap.zap(type(int128).max, REFERRER) {}
        catch (bytes memory reason) {
            assertEq(bytes4(reason), WrapperExceedsMaxAmount.selector);
        }

        vm.stopPrank();
    }

    function test_zap_in_event() public {
        vm.startPrank(ACTOR);

        USDC.approve(address(zap), UINT_AMOUNT);

        vm.expectEmit(true, true, true, false);
        emit ZappedIn(UINT_AMOUNT);

        zap.zap(INT_AMOUNT, REFERRER);

        vm.stopPrank();
    }
}

contract ZapOut is ZapTest {
    function test_zap_out() public {
        // $USDC has 6 decimals
        // $sUSD and $sUSDC have 18 decimals
        // thus, 1e12 $sUSD = 1 $USDC

        uint256 sUSDAmount = 1e12;
        uint256 usdcAmount = 1;

        vm.startPrank(ACTOR);

        SUSD.transfer(address(zap), sUSDAmount);

        zap.zap(-1e12, REFERRER);

        assertEq(USDC.balanceOf(address(zap)), usdcAmount);

        vm.stopPrank();
    }

    function test_zap_out_zero() public {
        vm.startPrank(ACTOR);

        vm.expectRevert(); // fails at buy()

        zap.zap(0, REFERRER);

        vm.stopPrank();
    }
}

contract Wrap is ZapTest {
    /**
     * example:
     *
     * 1 $USDC -- Synthetix Spot Market: Wrap --> 1e12 $sUSDC
     *                                                |
     *                                                |
     *                                    Synthetix Spot Market: Sell
     *                                                |
     *                                                |
     *                                                v
     *                                            1e12 $sUSD
     *
     */
    function test_synthetix_wrap() public {
        // $USDC has 6 decimals
        // $sUSD and $sUSDC have 18 decimals
        // thus, 1e12 $sUSD = 1 $USDC

        vm.startPrank(ACTOR);

        ISpotMarketProxy spotMarketProxy = ISpotMarketProxy(
            ZapExposed(address(zap)).expose_SPOT_MARKET_PROXY()
        );
        uint128 sUSDCId = ZapExposed(address(zap)).expose_SUSDC_SPOT_MARKET_ID();
        IERC20 sUSDC = IERC20(ZapExposed(address(zap)).expose_SUSDC());

        USDC.approve(address(spotMarketProxy), type(uint256).max);

        uint256 preSUSDCBalance = sUSDC.balanceOf(ACTOR);

        assertEq(preSUSDCBalance, 0);

        spotMarketProxy.wrap({
            marketId: sUSDCId,
            wrapAmount: UINT_AMOUNT,
            minAmountReceived: UINT_AMOUNT
        });

        uint256 postSUSDCBalance = sUSDC.balanceOf(ACTOR);

        assertEq(postSUSDCBalance - preSUSDCBalance, converted_UINT_AMOUNT);

        sUSDC.approve(address(spotMarketProxy), type(uint256).max);

        preSUSDCBalance = sUSDC.balanceOf(ACTOR);
        uint256 preSUSDBalance = SUSD.balanceOf(ACTOR);

        spotMarketProxy.sell({
            marketId: sUSDCId,
            synthAmount: converted_UINT_AMOUNT,
            minUsdAmount: converted_UINT_AMOUNT,
            referrer: REFERRER
        });

        postSUSDCBalance = sUSDC.balanceOf(ACTOR);
        uint256 postSUSDBalance = SUSD.balanceOf(ACTOR);

        assertEq(postSUSDCBalance, 0);
        assertEq(postSUSDBalance - preSUSDBalance, converted_UINT_AMOUNT);

        vm.stopPrank();
    }
}

contract Unwrap is ZapTest {
    /**
     * example:
     *
     * 1 $USDC <-- Synthetix Spot Market: Wrap -- 1e12 $sUSDC
     *                                                ^
     *                                                |
     *                                                |
     *                                    Synthetix Spot Market: Sell
     *                                                |
     *                                                |
     *                                            1e12 $sUSD
     *
     */
    function test_synthetix_unwrap() public {
        // $USDC has 6 decimals
        // $sUSD and $sUSDC have 18 decimals
        // thus, 1e12 $sUSD = 1 $USDC

        vm.startPrank(ACTOR);

        ISpotMarketProxy spotMarketProxy = ISpotMarketProxy(
            ZapExposed(address(zap)).expose_SPOT_MARKET_PROXY()
        );
        uint128 sUSDCId = ZapExposed(address(zap)).expose_SUSDC_SPOT_MARKET_ID();
        IERC20 sUSDC = IERC20(ZapExposed(address(zap)).expose_SUSDC());

        SUSD.approve(address(spotMarketProxy), type(uint256).max);

        uint256 preSUSDCBalance = sUSDC.balanceOf(ACTOR);

        assertEq(preSUSDCBalance, 0);

        spotMarketProxy.buy({
            marketId: sUSDCId,
            usdAmount: converted_UINT_AMOUNT,
            minAmountReceived: converted_UINT_AMOUNT,
            referrer: REFERRER
        });

        uint256 postSUSDCBalance = sUSDC.balanceOf(ACTOR);

        assertEq(postSUSDCBalance - preSUSDCBalance, converted_UINT_AMOUNT);

        sUSDC.approve(address(spotMarketProxy), type(uint256).max);

        preSUSDCBalance = sUSDC.balanceOf(ACTOR);

        uint256 preUSDCBalance = USDC.balanceOf(ACTOR);

        spotMarketProxy.unwrap({
            marketId: sUSDCId,
            unwrapAmount: converted_UINT_AMOUNT,
            minAmountReceived: UINT_AMOUNT
        });

        postSUSDCBalance = sUSDC.balanceOf(ACTOR);

        assertEq(postSUSDCBalance, 0);

        uint256 postUSDCBalance = USDC.balanceOf(ACTOR);

        assertEq(postUSDCBalance - preUSDCBalance, UINT_AMOUNT);
    }
}
