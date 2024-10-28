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

contract OdosSwapTest is Bootstrap {

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

        string memory pathId =
            abi.decode(vm.parseJson(string(quoteData), ".pathId"), (string));

        (uint256 assembleStatus, bytes memory assembleData) =
            odosAssemble(pathId);

        assertEq(assembleStatus, 200);

        bytes memory swapData =
            vm.parseJson(string(assembleData), ".transaction.data");
    }

    function test_odos_swap_arbitrum() public arbitrum {
        uint256 status;

        (uint256 quoteStatus, bytes memory quoteData) = getOdosQuote(
            ARBITRUM_CHAIN_ID,
            ARBITRUM_WETH,
            1 ether,
            ARBITRUM_USDC,
            DEFAULT_PROPORTION,
            DEFAULT_SLIPPAGE,
            address(zap)
        );

        assertEq(quoteStatus, 200);

        string memory pathId =
            abi.decode(vm.parseJson(string(quoteData), ".pathId"), (string));

        (uint256 assembleStatus, bytes memory assembleData) =
            odosAssemble(pathId);

        assertEq(assembleStatus, 200);

        bytes memory swapData =
            vm.parseJson(string(assembleData), ".transaction.data");
    }

}
