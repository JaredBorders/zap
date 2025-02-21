// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    Errors,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

import {MathLib} from "./utils/MathLib.sol";

contract UnwindTest is Bootstrap, Errors {

    using MathLib for int128;
    using MathLib for int256;
    using MathLib for uint256;

    address public constant DEBT_ACTOR =
        address(0x72A8EA777f5Aa58a1E5a405931e2ccb455B60088);
    uint128 public constant ACCOUNT_ID =
        170_141_183_460_469_231_731_687_303_715_884_105_766;
    uint256 public constant INITIAL_DEBT = 2_244_714_058_540_271_627;

    address constant USDC_ADDR = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address constant WETH_ADDR = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

    uint256 SWAP_AMOUNT = 1_352_346_556_314_334;

    bytes swapPath;
    string pathId;

    /// @custom:disabled no stata on arbitrum
    // function test_unwind_is_authorized() public arbitrum {
    //     vm.prank(ACTOR);
    //     vm.expectRevert(NotPermitted.selector);
    //     zap.unwind(0, 0, 0, address(0), "", /*todo*/ 0, 0, 0, address(0));
    // }

    // /// @custom:todo
    // function test_unwind_arbitrum() public arbitrum {
    //     IPerpsMarket perpsMarketProxy = IPerpsMarket(zap.PERPS_MARKET());
    //     uint256 initialAccountDebt = perpsMarketProxy.debt(ACCOUNT_ID);
    //     assertEq(initialAccountDebt, INITIAL_DEBT);

    //     int256 withdrawableMargin =
    //         perpsMarketProxy.getWithdrawableMargin(ACCOUNT_ID);

    //     /// While there is debt, withdrawable margin should be 0
    //     assertEq(withdrawableMargin, 0);

    //     int256 availableMargin = perpsMarketProxy.getAvailableMargin(ACCOUNT_ID);
    //     assertGt(availableMargin, 0);

    //     uint256 balanceBefore = IERC20(ARBITRUM_WETH).balanceOf(DEBT_ACTOR);

    //     vm.startPrank(DEBT_ACTOR);

    //     pathId = getOdosQuotePathId(
    //         ARBITRUM_CHAIN_ID, ARBITRUM_WETH, SWAP_AMOUNT, ARBITRUM_USDC
    //     );

    //     swapPath = getAssemblePath(pathId);

    //     zap.unwind({
    //         _accountId: ACCOUNT_ID,
    //         _collateralId: 4,
    //         _collateralAmount: 36_000_000_000_000_000,
    //         _collateral: WETH_ADDR,
    //         _path: swapPath,
    //         _zapMinAmountOut: 2_222_267_000_000_000_000,
    //         _unwrapMinAmountOut: 35_964_000_000_000_000,
    //         _swapAmountIn: SWAP_AMOUNT,
    //         _receiver: DEBT_ACTOR
    //     });

    //     vm.stopPrank();

    //     uint256 balanceAfter = IERC20(ARBITRUM_WETH).balanceOf(DEBT_ACTOR);

    //     assertGt(balanceAfter, balanceBefore);
    // }

}
