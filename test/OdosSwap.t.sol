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

import "forge-std/console2.sol";
import {Surl} from "surl/src/Surl.sol";

contract OdosSwapTest is Bootstrap {

    using Surl for *;

struct QuoteData {
    uint256 blockNumber;
    uint256 dataGasEstimate;
    uint256 gasEstimate;
    uint256 gasEstimateValue;
    uint256 gweiPerGas;
    uint256 inAmounts;
    uint256[] inValues;
    address inTokens;
    uint256 netOutValue;
    uint256 outAmounts;
    uint256[] outValues;
    address outTokens;
    uint256 partnerFeePercent;
    bytes32 pathId;
    bytes32 pathViz;
    uint256 percentDiff;
    int256 priceImpact;
}

    function test_odos_swap_base() public base {
        uint256 status;

        (uint256 quoteStatus, bytes memory quoteData) = getOdosQuote(
            BASE_CHAIN_ID,
            BASE_WETH,
            1 ether,
            BASE_USDC,
            DEFAULT_PROPORTION,
            DEFAULT_SLIPPAGE,
            address(zap)
        );

        assertEq(quoteStatus, 200);

        string memory pathId = abi.decode(vm.parseJson(string(quoteData), ".pathId"), (string));

        (uint256 assembleStatus, bytes memory assembleData) =
            odosAssemble(pathId);

        assertEq(assembleStatus, 200);
    }

    function test_odos_swap_arbitrum() public arbitrum {
        (uint256 status,) = getOdosQuote(
            ARBITRUM_CHAIN_ID,
            ARBITRUM_WETH,
            1 ether,
            ARBITRUM_USDC,
            DEFAULT_PROPORTION,
            DEFAULT_SLIPPAGE,
            address(zap)
        );
        assertEq(status, 200);
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

    function getOdosQuote(
        uint256 chainId,
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 proportionOut,
        uint256 slippageLimitPct,
        address userAddress
    )
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

        (status, data) = url.post(headers, params);
    }

    function odosAssemble(string memory pathId)
        internal
        returns (uint256 status, bytes memory data)
    {
        string[] memory headers = new string[](1);
        headers[0] = "Content-Type: application/json";

        string memory url = "https://api.odos.xyz/sor/assemble";

        string memory params = string.concat(
            '{"userAddr": "',
            vm.toString(address(zap)),
            '", "pathId": "',
            pathId,
            '", "simulate": ',
            vm.toString(true),
            '}'
        );

        console2.logString('params: ');
        console2.logString(params);

        (status, data) = url.post(headers, params);
    }

}
