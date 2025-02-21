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

contract SellTest is Bootstrap {

    function test_sell_base(uint32 amount) public base {
        _spin(ACTOR, usdx, amount, address(zap));
        vm.startPrank(ACTOR);
        (uint256 received,) = zap.buy({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
            _receiver: ACTOR
        });
        assertEq(usdx.balanceOf(ACTOR), 0);
        assertGe(susdc.balanceOf(ACTOR), DEFAULT_MIN_AMOUNT_OUT);
        susdc.approve(address(zap), type(uint256).max);
        received = zap.sell({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: received,
            _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertGe(received, DEFAULT_MIN_AMOUNT_OUT);
        assertGe(usdx.balanceOf(ACTOR), DEFAULT_MIN_AMOUNT_OUT);
        assertEq(susdc.balanceOf(ACTOR), 0);
    }

    /// @custom:disabled no stata on arbitrum
    // function test_sell_arbitrum(uint32 amount) public arbitrum {
    //     _spin(ACTOR, usdx, amount, address(zap));
    //     vm.startPrank(ACTOR);
    //     (uint256 received,) = zap.buy({
    //         _synthId: zap.SUSDC_SPOT_ID(),
    //         _amount: amount,
    //         _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
    //         _receiver: ACTOR
    //     });
    //     assertEq(usdx.balanceOf(ACTOR), 0);
    //     assertGe(susdc.balanceOf(ACTOR), DEFAULT_MIN_AMOUNT_OUT);
    //     susdc.approve(address(zap), type(uint256).max);
    //     received = zap.sell({
    //         _synthId: zap.SUSDC_SPOT_ID(),
    //         _amount: received,
    //         _minAmountOut: DEFAULT_MIN_AMOUNT_OUT,
    //         _receiver: ACTOR
    //     });
    //     vm.stopPrank();
    //     assertGe(received, DEFAULT_MIN_AMOUNT_OUT);
    //     assertGe(usdx.balanceOf(ACTOR), DEFAULT_MIN_AMOUNT_OUT);
    //     assertEq(susdc.balanceOf(ACTOR), 0);
    // }

}
