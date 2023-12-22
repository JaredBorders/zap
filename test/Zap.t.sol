// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {Bootstrap} from "test/utils/Bootstrap.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";
import {ZapExposed} from "test/utils/exposed/ZapExposed.sol";

contract ZapTest is Bootstrap {
    IERC20 internal SUSD;
    IERC20 internal USDC;

    function setUp() public {
        vm.rollFork(BASE_BLOCK_NUMBER);
        initializeBase();

        SUSD = IERC20(ZapExposed(address(zap)).expose_SUSD());
        USDC = IERC20(ZapExposed(address(zap)).expose_USDC());

        deal(address(SUSD), ACTOR, UINT_ONE_HUNDRED);
        deal(address(USDC), ACTOR, UINT_ONE_HUNDRED);
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

        USDC.approve(address(zap), UINT_ONE_HUNDRED);

        zap.zap(INT_ONE_HUNDRED, REFERRER);

        assertEq(SUSD.balanceOf(address(zap)), UINT_ONE_HUNDRED);

        vm.stopPrank();
    }

    /// @dev test assumes the wrapper cap is always < 2^255 - 1 (max int128)
    function test_zap_in_exceeds_cap() public {
        // convert to uint256 for deal/approval
        uint256 cap = type(uint128).max;

        deal(address(USDC), ACTOR, cap);

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

        USDC.approve(address(zap), UINT_ONE_HUNDRED);

        vm.expectEmit(true, true, true, false);
        emit ZappedIn(UINT_ONE_HUNDRED);

        zap.zap(INT_ONE_HUNDRED, REFERRER);

        vm.stopPrank();
    }
}

contract ZapOut is ZapTest {
    // function test_zap_out() public {
    //     vm.startPrank(ACTOR);

    //     SUSD.transfer(address(zap), UINT_ONE_HUNDRED);

    //     zap.zap(INT_NEGATIVE_ONE_HUNDRED, REFERRER);

    //     assertEq(USDC.balanceOf(address(zap)), UINT_ONE_HUNDRED);

    //     vm.stopPrank();
    // }

    function test_zap_out_zero() public {
        vm.startPrank(ACTOR);

        vm.expectRevert(); // fails at buy()

        zap.zap(0, REFERRER);

        vm.stopPrank();
    }
}
