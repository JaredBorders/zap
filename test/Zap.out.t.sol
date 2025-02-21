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

contract ZapOutTest is Bootstrap {

    function test_zap_out_base(uint32 amount) public base {
        /// @dev setup by zapping in because
        /// cant _spin sstata
        _spin(ACTOR, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(ACTOR), amount);
        assertEq(sstata.balanceOf(ACTOR), 0);
        vm.startPrank(ACTOR);
        uint256 zapped = zap.zapIn({
            _amount: amount,
            _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
            _receiver: ACTOR
        });

        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(sstata.balanceOf(ACTOR), zapped);
        vm.startPrank(ACTOR);
        sstata.approve(address(zap), zapped);
        zapped = zap.zapOut({
            _amount: zapped,
            _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertGe(zapped, DEFAULT_MIN_AMOUNT_OUT);
        assertEq(usdc.balanceOf(ACTOR), zapped);
        assertEq(sstata.balanceOf(ACTOR), 0);
    }

    /// @custom:disabled no stata on arbitrum
    // function test_zap_out_arbitum(uint64 amount) public arbitrum {
    //     vm.assume(amount > 1e18);
    //     _spin(ACTOR, usdx, amount, address(zap));
    //     assertEq(usdc.balanceOf(ACTOR), 0);
    //     assertEq(usdx.balanceOf(ACTOR), amount);
    //     vm.startPrank(ACTOR);
    //     uint256 zapped = zap.zapOut({
    //         _amount: amount,
    //         _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
    //         _receiver: ACTOR
    //     });
    //     vm.stopPrank();
    //     assertGe(zapped, DEFAULT_MIN_AMOUNT_OUT);
    //     assertEq(usdc.balanceOf(ACTOR), zapped);
    //     assertEq(usdx.balanceOf(ACTOR), 0);
    // }

}
