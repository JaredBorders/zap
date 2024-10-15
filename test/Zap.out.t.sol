// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

contract ZapOutTest is Bootstrap {

    function test_zap_out_base(uint32 amount) public base {
        _spin(ACTOR, usdx, amount, address(zap));
        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(usdx.balanceOf(ACTOR), amount);
        vm.startPrank(ACTOR);
        uint256 zapped = zap.zapOut({
            _amount: amount,
            _minAmountOut: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertGe(zapped, DEFAULT_TOLERANCE);
        assertEq(usdc.balanceOf(ACTOR), zapped);
        assertEq(usdx.balanceOf(ACTOR), 0);
    }

    function test_zap_out_arbitum(uint32 amount) public arbitrum {
        _spin(ACTOR, usdx, amount, address(zap));
        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(usdx.balanceOf(ACTOR), amount);
        vm.startPrank(ACTOR);
        uint256 zapped = zap.zapOut({
            _amount: amount,
            _minAmountOut: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertGe(zapped, DEFAULT_TOLERANCE);
        assertEq(usdc.balanceOf(ACTOR), zapped);
        assertEq(usdx.balanceOf(ACTOR), 0);
    }

}
