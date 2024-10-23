// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    IERC20,
    IFactory,
    IFactory,
    IPerpsMarket,
    IPool,
    IRouter,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";
import {Surl} from "surl/src/Surl.sol";
import "forge-std/console2.sol";

contract OdosSwapTest is Bootstrap {

    using Surl for *;

    function test_odos_swap_base() public base {
        getOdosQuote(BASE_CHAIN_ID, BASE_WETH, 1 ether, BASE_USDC, DEFAULT_PROPORTION, DEFAULT_SLIPPAGE, address(zap));
    }

    // function test_swap_for_single_arbitrum(uint8 percentage) public arbitrum
    // {
    //     vm.assume(percentage < 95 && percentage > 0);

    //     uint256 _maxAmountIn = type(uint256).max;
    //     _spin(ACTOR, weth, _maxAmountIn, address(zap));

    //     address pool = IFactory(IRouter(zap.ROUTER()).factory()).getPool(
    //         address(weth), address(usdc), zap.FEE_TIER()
    //     );
    //     uint256 depth = usdc.balanceOf(pool);
    //     uint256 amount = depth * (percentage / 100);

    //     assertEq(usdc.balanceOf(ACTOR), 0);
    //     assertEq(weth.balanceOf(ACTOR), _maxAmountIn);

    //     vm.startPrank(ACTOR);

    //     if (amount == 0) {
    //         vm.expectRevert();
    //     }

    //     zap.swapFor({
    //         _from: address(weth),
    //         _path: abi.encodePacked(address(usdc), FEE_5, address(weth)),
    //         _amount: amount,
    //         _maxAmountIn: _maxAmountIn,
    //         _receiver: ACTOR
    //     });

    //     assertTrue(
    //         amount > 1e6
    //             ? usdc.balanceOf(ACTOR) < 0
    //             : usdc.balanceOf(ACTOR) == 0
    //     );
    //     assertLe(weth.balanceOf(ACTOR), _maxAmountIn);
    //     assertEq(weth.allowance(address(zap), zap.ROUTER()), 0);

    //     vm.stopPrank();
    // }

    // /// @custom:todo
    // function test_swap_for_single_arbitrum_sepolia() public arbitrum_sepolia
    // {}

    // function test_swap_for_multihop_base() public base {
    //     uint256 amount = 100e6;
    //     uint256 _maxAmountIn = type(uint256).max / 4;
    //     _spin(ACTOR, tbtc, _maxAmountIn, address(zap));
    //     assertEq(usdc.balanceOf(ACTOR), 0);
    //     assertEq(tbtc.balanceOf(ACTOR), _maxAmountIn);
    //     vm.startPrank(ACTOR);
    //     zap.swapFor({
    //         _from: address(tbtc),
    //         _path: abi.encodePacked(
    //             address(usdc), FEE_30, address(weth), FEE_30, address(tbtc)
    //         ),
    //         _amount: amount,
    //         _maxAmountIn: _maxAmountIn,
    //         _receiver: ACTOR
    //     });
    //     assertGt(usdc.balanceOf(ACTOR), 0);
    //     assertLt(tbtc.balanceOf(ACTOR), _maxAmountIn);
    //     assertEq(tbtc.allowance(address(zap), zap.ROUTER()), 0);
    //     vm.stopPrank();
    // }

    // function test_swap_for_multihop_arbitrum() public arbitrum {
    //     uint256 amount = 100e6;
    //     uint256 _maxAmountIn = type(uint256).max / 4;
    //     _spin(ACTOR, tbtc, _maxAmountIn, address(zap));
    //     assertEq(usdc.balanceOf(ACTOR), 0);
    //     assertEq(tbtc.balanceOf(ACTOR), _maxAmountIn);

    //     vm.startPrank(ACTOR);
    //     zap.swapFor({
    //         _from: address(tbtc),
    //         _path: abi.encodePacked(
    //             address(usdc), FEE_5, address(weth), FEE_5, address(tbtc)
    //         ),
    //         _amount: amount,
    //         _maxAmountIn: _maxAmountIn,
    //         _receiver: ACTOR
    //     });
    //     assertGt(usdc.balanceOf(ACTOR), 0);
    //     assertLt(tbtc.balanceOf(ACTOR), _maxAmountIn);
    //     assertEq(tbtc.allowance(address(zap), zap.ROUTER()), 0);
    //     vm.stopPrank();
    // }

    function getOdosQuote(uint256 chainId, address tokenIn, uint256 amountIn, address tokenOut, uint256 proportionOut, uint256 slippageLimitPct, address userAddress)
        internal
        returns (uint256 status, bytes memory data)
    {
        // Perform a post request with headers and JSON body
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";

        string memory url = "https://api.odos.xyz/sor/quote/v2";
        string memory params = string.concat(
            '{"chainId": ',
            vm.toString(chainId),
            ', "inputTokens": [{"tokenAddress": "',
            vm.toString(tokenIn),
            '", "amount": "',
            vm.toString(amountIn),
            '"}],"outputTokens": [{"tokenAddress": "',
            vm.toString(tokenOut),
            '", "proportion": ',
            vm.toString(proportionOut),
            '}], "slippageLimitPercent": ',
            vm.toString(slippageLimitPct),
            ', "userAddr": "',
            vm.toString(userAddress),
            '"}'
        );
        console2.logString(params);

        (status, data) = url.post(headers, params);

        console2.logBytes("status: ");
        console2.logUint(status);
        console2.logBytes("data: ");
        console2.logString(string(data));
    }

}
