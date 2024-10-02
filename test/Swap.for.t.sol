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

contract SwapForTest is Bootstrap {

    /// @custom:todo
    function test_swap_for_base(uint256 _amount, uint256 _tolerance, address _eoa, address _receiver) public base {
        vm.assume(_amount > 0);
        _spin(_eoa, weth, _amount, address(zap));

        uint256 usdcBalanceBefore = usdc.balanceOf(_receiver);
        uint256 wethBalanceBefore = weth.balanceOf(_receiver);

        vm.prank(_eoa);
        uint256 deducted = zap.swapFor(address(weth), _eoa, _amount, _amount / 2, _receiver);

        uint256 usdcBalanceAfter = usdc.balanceOf(_receiver);
        uint256 wethBalanceAfter = weth.balanceOf(_receiver);

        assertGt(wethBalanceAfter, wethBalanceBefore);
        assertLt(usdcBalanceAfter, usdcBalanceBefore);
    }

    /// @custom:todo
    function test_swap_for_arbitrum() public arbitrum {}

    /// @custom:todo
    function test_swap_for_arbitrum_sepolia() public arbitrum_sepolia {}

}
