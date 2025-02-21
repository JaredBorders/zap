// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Zap
} from "./utils/Bootstrap.sol";

contract ZapInTest is Bootstrap {

    function test_zap_in_base(uint32 amount) public base {
        _spin(ACTOR, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(ACTOR), amount);
        assertEq(sstata.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        uint256 zapped = zap.zapIn({
            _amount: amount,
            _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertGe(zapped, DEFAULT_MIN_AMOUNT_OUT);
        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(sstata.balanceOf(ACTOR), zapped);
    }

    /// @custom:disabled no stata on arbitrum
    // function test_zap_in_arbitrum(uint32 amount) public arbitrum {
    //     _spin(ACTOR, usdc, amount, address(zap));
    //     assertEq(usdc.balanceOf(ACTOR), amount);
    //     assertEq(usdx.balanceOf(ACTOR), 0);
    //     vm.startPrank(ACTOR);
    //     uint256 zapped = zap.zapIn({
    //         _amount: amount,
    //         _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
    //         _receiver: ACTOR
    //     });
    //     vm.stopPrank();
    //     assertGe(zapped, DEFAULT_MIN_AMOUNT_OUT);
    //     assertEq(usdc.balanceOf(ACTOR), 0);
    //     assertEq(usdx.balanceOf(ACTOR), zapped);
    // }

}
