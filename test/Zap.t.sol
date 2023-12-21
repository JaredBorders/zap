// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {Bootstrap, Zap} from "test/utils/Bootstrap.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";
import {ZapExposed} from "test/utils/exposed/ZapExposed.sol";

contract ZapTest is Bootstrap {
    IERC20 internal SUSD;
    IERC20 internal USDC;

    Zap.ZapDetails internal details;

    function setUp() public {
        vm.rollFork(BASE_BLOCK_NUMBER);
        initializeBase();

        SUSD = IERC20(ZapExposed(address(zap)).expose_SUSD());
        USDC = IERC20(ZapExposed(address(zap)).expose_USDC());

        deal(address(SUSD), ACTOR, UINT_ONE_HUNDRED);
        deal(address(USDC), ACTOR, UINT_ONE_HUNDRED);
    }

    function test_usdc_zero_address() public {
        vm.expectRevert();

        new ZapExposed({
            _usdc: address(0),
            _susd: address(0x1),
            _spotMarketProxy: address(0x1)
        });
    }

    function test_susd_zero_address() public {
        vm.expectRevert();

        new ZapExposed({
            _usdc: address(0x1),
            _susd: address(0),
            _spotMarketProxy: address(0x1)
        });
    }

    function test_spotMarketProxy_zero_address() public {
        vm.expectRevert();

        new ZapExposed({
            _usdc: address(0x1),
            _susd: address(0x1),
            _spotMarketProxy: address(0)
        });
    }
}

contract VerifySynthMarketId is ZapTest {
    function test_verifySynthMarketId_true() public {
        // correctly verfies 
    }
}

contract ZapIn is ZapTest {
    function test_zap_in() public {
        details = Zap.ZapDetails({
            sUSDCMarketId: sUSDCMarketId,
            amount: INT_ONE_HUNDRED,
            referrer: REFERRER
        });

        vm.startPrank(ACTOR);

        USDC.approve(address(zap), UINT_ONE_HUNDRED);

        zap.zap(details);

        assertEq(SUSD.balanceOf(address(zap)), UINT_ONE_HUNDRED);

        vm.stopPrank();
    }

    function test_zap_in_exceeds_cap() public {
        // determine if there is a cap and how to find it
        // deal x USDC to ACTOR where x > cap
        // attempt to zap

        assertEq(true, false);
    }

    function test_zap_in_event() public {
        details = Zap.ZapDetails({
            sUSDCMarketId: sUSDCMarketId,
            amount: INT_ONE_HUNDRED,
            referrer: REFERRER
        });

        vm.startPrank(ACTOR);

        USDC.approve(address(zap), UINT_ONE_HUNDRED);

        vm.expectEmit(true, true, true, false);
        emit ZappedIn(UINT_ONE_HUNDRED);

        zap.zap(details);

        vm.stopPrank();
    }
}

contract ZapOut is ZapTest {
    function test_zap_out() public {
        details = Zap.ZapDetails({
            sUSDCMarketId: sUSDCMarketId,
            amount: INT_NEGATIVE_ONE_HUNDRED,
            referrer: REFERRER
        });

        vm.startPrank(ACTOR);

        SUSD.transfer(address(zap), UINT_ONE_HUNDRED);

        zap.zap(details);

        assertEq(USDC.balanceOf(address(zap)), UINT_ONE_HUNDRED);

        vm.stopPrank();
    }

    function test_zap_out_zero() public {
        assertEq(true, false);
    }

    function test_zap_out_exceeds_cap() public {
        assertEq(true, false);
    }

    function test_zap_out_event() public {
        details = Zap.ZapDetails({
            sUSDCMarketId: sUSDCMarketId,
            amount: INT_NEGATIVE_ONE_HUNDRED,
            referrer: REFERRER
        });

        vm.startPrank(ACTOR);

        SUSD.transfer(address(zap), UINT_ONE_HUNDRED);

        vm.expectEmit(true, true, true, false);
        emit ZappedOut(UINT_ONE_HUNDRED);

        zap.zap(details);

        vm.stopPrank();
    }
}
