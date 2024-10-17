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

contract WrapTest is Bootstrap {

    function test_wrap_base(uint32 amount) public base {
        _spin(ACTOR, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(ACTOR), amount);
        assertEq(susdc.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        uint256 wrapped = zap.wrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertGe(wrapped, DEFAULT_TOLERANCE);
        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(susdc.balanceOf(ACTOR), wrapped);
    }

    function test_wrap_arbitrum(uint32 amount) public arbitrum {
        _spin(ACTOR, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(ACTOR), amount);
        assertEq(susdc.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        uint256 wrapped = zap.wrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: DEFAULT_TOLERANCE,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertGe(wrapped, DEFAULT_TOLERANCE);
        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(susdc.balanceOf(ACTOR), wrapped);
    }

}
