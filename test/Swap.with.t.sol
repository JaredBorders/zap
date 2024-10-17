// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    IERC20,
    IFactory,
    IPerpsMarket,
    IPool,
    IRouter,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

contract SwapWithTest is Bootstrap {

    /// @custom:todo
    function test_swap_with_base(uint8 percentage) public base {
        vm.assume(percentage < 95 && percentage > 0);

        uint256 tolerance = type(uint256).max;
        _spin(ACTOR, weth, tolerance, address(zap));

        address pool = IFactory(IRouter(zap.ROUTER()).factory()).getPool(
            address(weth), address(usdc), zap.FEE_TIER()
        );
        uint256 depth = usdc.balanceOf(pool);
        uint256 amount = depth * (percentage / 100);

        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(weth.balanceOf(ACTOR), tolerance);

        vm.startPrank(ACTOR);

        if (amount == 0) {
            vm.expectRevert();
        }

        zap.swapWith({
            _from: address(weth),
            _path: abi.encodePacked(address(weth), FEE_30, address(usdx)),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: ACTOR
        });

        assertTrue(
            amount > 1e6
                ? usdc.balanceOf(ACTOR) < 0
                : usdc.balanceOf(ACTOR) == 0
        );
        assertLe(weth.balanceOf(ACTOR), tolerance);
        assertEq(weth.allowance(address(zap), zap.ROUTER()), 0);

        vm.stopPrank();
    }

    /// @custom:todo
    function test_swap_with_arbitrum(uint8 percentage) public arbitrum {
        vm.assume(percentage < 95 && percentage > 0);

        uint256 tolerance = type(uint256).max;
        _spin(ACTOR, weth, tolerance, address(zap));

        address pool = IFactory(IRouter(zap.ROUTER()).factory()).getPool(
            address(weth), address(usdc), zap.FEE_TIER()
        );
        uint256 depth = usdc.balanceOf(pool);
        uint256 amount = depth * (percentage / 100);

        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(weth.balanceOf(ACTOR), tolerance);

        vm.startPrank(ACTOR);

        if (amount == 0) {
            vm.expectRevert();
        }

        zap.swapWith({
            _from: address(weth),
            _path: abi.encodePacked(address(weth), FEE_30, address(usdc)),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: ACTOR
        });

        assertTrue(
            amount > 1e6
                ? usdc.balanceOf(ACTOR) < 0
                : usdc.balanceOf(ACTOR) == 0
        );
        assertLe(weth.balanceOf(ACTOR), tolerance);
        assertEq(weth.allowance(address(zap), zap.ROUTER()), 0);

        vm.stopPrank();
    }

    /// @custom:todo
    function test_swap_with_arbitrum_sepolia() public arbitrum_sepolia {}

}
