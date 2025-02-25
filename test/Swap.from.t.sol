// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Constants,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";
import {BootstrapWithCurrentBlock} from "./utils/BootstrapWithCurrentBlock.sol";

contract SwapFromTest is BootstrapWithCurrentBlock {

    bytes swapPath;
    string pathId;

    function test_swap_from_weth_base() public base {
        {
            _spin(ACTOR, weth, DEFAULT_AMOUNT, address(zap));
            assertEq(usdc.balanceOf(ACTOR), 0);
            assertEq(weth.balanceOf(ACTOR), DEFAULT_AMOUNT);
            assertEq(usdc.balanceOf(address(zap)), 0);
            assertEq(weth.balanceOf(address(zap)), 0);

            pathId = getOdosQuotePathId(
                BASE_CHAIN_ID, BASE_WETH, DEFAULT_AMOUNT, BASE_USDC
            );

            swapPath = getAssemblePath(pathId);
        }

        vm.startPrank(ACTOR);
        uint256 amountOut = zap.swapFrom({
            _from: BASE_WETH,
            _path: swapPath,
            _amountIn: DEFAULT_AMOUNT,
            _receiver: ACTOR
        });

        assertEq(usdc.balanceOf(ACTOR), amountOut);
        assertEq(weth.balanceOf(ACTOR), 0);
        assertEq(usdc.balanceOf(address(zap)), 0);
        assertEq(weth.balanceOf(address(zap)), 0);
    }

    function test_swap_from_weth_arbitrum() public arbitrum {
        {
            _spin(ACTOR, weth, DEFAULT_AMOUNT, address(zap));
            assertEq(usdc.balanceOf(ACTOR), 0);
            assertEq(weth.balanceOf(ACTOR), DEFAULT_AMOUNT);
            assertEq(usdc.balanceOf(address(zap)), 0);
            assertEq(weth.balanceOf(address(zap)), 0);

            pathId = getOdosQuotePathId(
                ARBITRUM_CHAIN_ID, ARBITRUM_WETH, DEFAULT_AMOUNT, ARBITRUM_USDC
            );

            swapPath = getAssemblePath(pathId);
        }

        vm.startPrank(ACTOR);
        uint256 amountOut = zap.swapFrom({
            _from: ARBITRUM_WETH,
            _path: swapPath,
            _amountIn: DEFAULT_AMOUNT,
            _receiver: ACTOR
        });

        assertEq(usdc.balanceOf(ACTOR), amountOut);
        assertEq(weth.balanceOf(ACTOR), 0);
        assertEq(usdc.balanceOf(address(zap)), 0);
        assertEq(weth.balanceOf(address(zap)), 0);
    }

    function test_swap_from_tbtc_arbitrum() public arbitrum {
        {
            _spin(ACTOR, tbtc, DEFAULT_AMOUNT, address(zap));
            assertEq(usdc.balanceOf(ACTOR), 0);
            assertEq(tbtc.balanceOf(ACTOR), DEFAULT_AMOUNT);
            assertEq(usdc.balanceOf(address(zap)), 0);
            assertEq(tbtc.balanceOf(address(zap)), 0);

            pathId = getOdosQuotePathId(
                ARBITRUM_CHAIN_ID, ARBITRUM_TBTC, DEFAULT_AMOUNT, ARBITRUM_USDC
            );

            swapPath = getAssemblePath(pathId);
        }

        vm.startPrank(ACTOR);
        uint256 amountOut = zap.swapFrom({
            _from: ARBITRUM_TBTC,
            _path: swapPath,
            _amountIn: DEFAULT_AMOUNT,
            _receiver: ACTOR
        });

        assertEq(usdc.balanceOf(ACTOR), amountOut);
        assertEq(tbtc.balanceOf(ACTOR), 0);
        assertEq(usdc.balanceOf(address(zap)), 0);
        assertEq(tbtc.balanceOf(address(zap)), 0);
    }

    function test_swap_from_tbtc_base() public base {
        {
            _spin(ACTOR, tbtc, DEFAULT_AMOUNT, address(zap));
            assertEq(usdc.balanceOf(ACTOR), 0);
            assertEq(tbtc.balanceOf(ACTOR), DEFAULT_AMOUNT);
            assertEq(usdc.balanceOf(address(zap)), 0);
            assertEq(tbtc.balanceOf(address(zap)), 0);

            pathId = getOdosQuotePathId(
                BASE_CHAIN_ID, BASE_TBTC, DEFAULT_AMOUNT, BASE_USDC
            );

            swapPath = getAssemblePath(pathId);
        }

        vm.startPrank(ACTOR);
        uint256 amountOut = zap.swapFrom({
            _from: BASE_TBTC,
            _path: swapPath,
            _amountIn: DEFAULT_AMOUNT,
            _receiver: ACTOR
        });

        assertEq(usdc.balanceOf(ACTOR), amountOut);
        assertEq(tbtc.balanceOf(ACTOR), 0);
        assertEq(usdc.balanceOf(address(zap)), 0);
        assertEq(tbtc.balanceOf(address(zap)), 0);
    }

}
