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

    function test_swap_for_base() public base {
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

    //     function getOdosPath(
    //     uint256 chainId,
    //     address tokenIn,
    //     uint256 amountIn,
    //     address tokenOut,
    //     uint256 proportionOut,
    //     uint256 slippageLimitPct,
    //     address userAddress
    // ) internal returns (bytes memory data) {
    //     (, bytes memory quoteData) = getOdosQuote(
    //         chainId,
    //         tokenIn,
    //         amountIn,
    //         tokenOut,
    //         proportionOut,
    //         slippageLimitPct,
    //         userAddress
    //     );
    //     string memory pathId =
    //         abi.decode(vm.parseJson(string(quoteData), ".pathId"), (string));

    //     (, bytes memory assembleData) =
    //         odosAssemble(pathId);

    //     data =
    //         vm.parseJson(string(assembleData), ".transaction.data");
    // }

    // function test_swap_for_single_base() public base {
    //     uint256 amount = 100e6;
    //     uint256 _maxAmountIn = type(uint256).max / 4;
    //     _spin(ACTOR, weth, _maxAmountIn, address(zap));
    //     assertEq(usdc.balanceOf(ACTOR), 0);
    //     assertEq(weth.balanceOf(ACTOR), _maxAmountIn);
    //     vm.startPrank(ACTOR);
    //     zap.swapFor({
    //         _from: address(weth),
    //         _path: abi.encodePacked(address(usdc), FEE_30, address(weth)),
    //         _amount: amount,
    //         _maxAmountIn: _maxAmountIn,
    //         _receiver: ACTOR
    //     });
    //     assertGt(usdc.balanceOf(ACTOR), 0);
    //     assertLt(weth.balanceOf(ACTOR), _maxAmountIn);
    //     assertEq(weth.allowance(address(zap), zap.ROUTER()), 0);
    //     vm.stopPrank();
    // }

    //     function test_swap_for_single_arbitrum(uint8 percentage) public
    // arbitrum
    // {
    //         vm.assume(percentage < 95 && percentage > 0);

    //         uint256 _maxAmountIn = type(uint256).max;
    //         _spin(ACTOR, weth, _maxAmountIn, address(zap));

    //         address pool = IFactory(IRouter(zap.ROUTER()).factory()).getPool(
    //             address(weth), address(usdc), zap.FEE_TIER()
    //         );
    //         uint256 depth = usdc.balanceOf(pool);
    //         uint256 amount = depth * (percentage / 100);

    //         assertEq(usdc.balanceOf(ACTOR), 0);
    //         assertEq(weth.balanceOf(ACTOR), _maxAmountIn);

    //         vm.startPrank(ACTOR);

    //         if (amount == 0) {
    //             vm.expectRevert();
    //         }

    //         zap.swapFor({
    //             _from: address(weth),
    //             _path: abi.encodePacked(address(usdc), FEE_5, address(weth)),
    //             _amount: amount,
    //             _maxAmountIn: _maxAmountIn,
    //             _receiver: ACTOR
    //         });

    //         assertTrue(
    //             amount > 1e6
    //                 ? usdc.balanceOf(ACTOR) < 0
    //                 : usdc.balanceOf(ACTOR) == 0
    //         );
    //         assertLe(weth.balanceOf(ACTOR), _maxAmountIn);
    //         assertEq(weth.allowance(address(zap), zap.ROUTER()), 0);

    //         vm.stopPrank();
    //     }

    /// @custom:todo
    //     function test_swap_for_single_arbitrum_sepolia() public
    // arbitrum_sepolia
    // {}

    //     function test_swap_for_multihop_base() public base {
    //         uint256 amount = 100e6;
    //         uint256 _maxAmountIn = type(uint256).max / 4;
    //         _spin(ACTOR, tbtc, _maxAmountIn, address(zap));
    //         assertEq(usdc.balanceOf(ACTOR), 0);
    //         assertEq(tbtc.balanceOf(ACTOR), _maxAmountIn);
    //         vm.startPrank(ACTOR);
    //         zap.swapFor({
    //             _from: address(tbtc),
    //             _path: abi.encodePacked(
    //                 address(usdc), FEE_30, address(weth), FEE_30,
    // address(tbtc)
    //             ),
    //             _amount: amount,
    //             _maxAmountIn: _maxAmountIn,
    //             _receiver: ACTOR
    //         });
    //         assertGt(usdc.balanceOf(ACTOR), 0);
    //         assertLt(tbtc.balanceOf(ACTOR), _maxAmountIn);
    //         assertEq(tbtc.allowance(address(zap), zap.ROUTER()), 0);
    //         vm.stopPrank();
    //     }

    //     function test_swap_for_multihop_arbitrum() public arbitrum {
    //         uint256 amount = 100e6;
    //         uint256 _maxAmountIn = type(uint256).max / 4;
    //         _spin(ACTOR, tbtc, _maxAmountIn, address(zap));
    //         assertEq(usdc.balanceOf(ACTOR), 0);
    //         assertEq(tbtc.balanceOf(ACTOR), _maxAmountIn);

    //         vm.startPrank(ACTOR);
    //         zap.swapFor({
    //             _from: address(tbtc),
    //             _path: abi.encodePacked(
    //                 address(usdc), FEE_5, address(weth), FEE_5, address(tbtc)
    //             ),
    //             _amount: amount,
    //             _maxAmountIn: _maxAmountIn,
    //             _receiver: ACTOR
    //         });
    //         assertGt(usdc.balanceOf(ACTOR), 0);
    //         assertLt(tbtc.balanceOf(ACTOR), _maxAmountIn);
    //         assertEq(tbtc.allowance(address(zap), zap.ROUTER()), 0);
    //         vm.stopPrank();
    //     }

}
