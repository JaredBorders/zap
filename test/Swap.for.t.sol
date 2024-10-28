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

contract SwapForTest is Bootstrap {

    bytes swapPath;
    string pathId;

    function test_swap_for_weth_base() public base {
        {
            _spin(ACTOR, weth, DEFAULT_AMOUNT, address(zap));
            assertEq(usdc.balanceOf(ACTOR), 0);
            assertEq(weth.balanceOf(ACTOR), DEFAULT_AMOUNT);

            pathId = getOdosQuotePathId(
                BASE_CHAIN_ID, BASE_WETH, DEFAULT_AMOUNT, BASE_USDC
            );

            swapPath = getAssemblePath(pathId);
        }

        vm.startPrank(ACTOR);
        zap.swapFor({
            _from: BASE_WETH,
            _path: swapPath,
            _amountIn: DEFAULT_AMOUNT,
            _receiver: ACTOR
        });
    }

    function test_swap_for_weth_arbitrum() public arbitrum {
        {
            _spin(ACTOR, weth, DEFAULT_AMOUNT, address(zap));
            assertEq(usdc.balanceOf(ACTOR), 0);
            assertEq(weth.balanceOf(ACTOR), DEFAULT_AMOUNT);

            pathId = getOdosQuotePathId(
                ARBITRUM_CHAIN_ID, ARBITRUM_WETH, DEFAULT_AMOUNT, ARBITRUM_USDC
            );

            swapPath = getAssemblePath(pathId);
        }

        vm.startPrank(ACTOR);
        zap.swapFor({
            _from: ARBITRUM_WETH,
            _path: swapPath,
            _amountIn: DEFAULT_AMOUNT,
            _receiver: ACTOR
        });
    }

    function test_swap_for_tbtc_arbitrum() public arbitrum {
        {
            _spin(ACTOR, tbtc, DEFAULT_AMOUNT, address(zap));
            assertEq(usdc.balanceOf(ACTOR), 0);
            assertEq(tbtc.balanceOf(ACTOR), DEFAULT_AMOUNT);

            pathId = getOdosQuotePathId(
                ARBITRUM_CHAIN_ID, ARBITRUM_TBTC, DEFAULT_AMOUNT, ARBITRUM_USDC
            );

            swapPath = getAssemblePath(pathId);
        }

        vm.startPrank(ACTOR);
        zap.swapFor({
            _from: ARBITRUM_TBTC,
            _path: swapPath,
            _amountIn: DEFAULT_AMOUNT,
            _receiver: ACTOR
        });
    }

}
