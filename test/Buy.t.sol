// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    ICore,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

contract BuyTest is Bootstrap {

    function test_buy_base(uint32 amount) public base {
        _spin(ACTOR, usdx, amount, address(zap));
        assertEq(usdx.balanceOf(ACTOR), amount);
        assertEq(susdc.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        (uint256 received, address synth) = zap.buy({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertEq(synth, address(susdc));
        assertGe(received, DEFAULT_TOLERANCE);
        assertEq(usdx.balanceOf(ACTOR), 0);
        assertGe(susdc.balanceOf(ACTOR), DEFAULT_TOLERANCE);
    }

    function test_buy_arbitrum(uint32 amount) public arbitrum {
        _spin(ACTOR, usdx, amount, address(zap));
        assertEq(usdx.balanceOf(ACTOR), amount);
        assertEq(susdc.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        (uint256 received, address synth) = zap.buy({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertEq(synth, address(susdc));
        assertGe(received, DEFAULT_TOLERANCE);
        assertEq(usdx.balanceOf(ACTOR), 0);
        assertGe(susdc.balanceOf(ACTOR), DEFAULT_TOLERANCE);
    }

}
