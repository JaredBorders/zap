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

contract SwapTest is Bootstrap {

    function test_swap_base() public base {
        uint256 amount = 1 ether;
        _spin(ACTOR, weth, amount, address(zap));
        assertEq(weth.balanceOf(ACTOR), amount);
        assertEq(usdc.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        uint256 received = zap.swap({
            _from: address(weth),
            _amount: amount,
            _tolerance: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertEq(weth.balanceOf(ACTOR), 0);
        assertEq(usdc.balanceOf(ACTOR), received);
        assertTrue(received > 0);
    }

    function test_swap_arbitrum() public arbitrum {
        uint256 amount = 1 ether;
        _spin(ACTOR, weth, amount, address(zap));
        assertEq(weth.balanceOf(ACTOR), amount);
        assertEq(usdc.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        uint256 received = zap.swap({
            _from: address(weth),
            _amount: amount,
            _tolerance: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertEq(weth.balanceOf(ACTOR), 0);
        assertEq(usdc.balanceOf(ACTOR), received);
        assertTrue(received > 0);
    }

}
