// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    ICore,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

contract FlashTest is Bootstrap {

    /// @custom:todo on arbitrum sepolia fork
    function test_flash_arbitrum_sepolia() public {
        /**
         * // 0. define bob;
         *     vm.startPrank(ARBITRUM_BOB);
         *
         *     // 1. define amount; 1000 usdx == $1000
         *     uint128 amount = 1000 ether;
         *
         *     // 2. spin up bob with 1000 usdx
         *     _spin(ARBITRUM_BOB, usdx, amount, address(zap));
         *
         *     // 3. create perp market account
         *     uint128 accountId = perpsMarket.createAccount();
         *
         *     // 4. grant perp market usdx allowance
         *     usdx.approve(address(perpsMarket), type(uint256).max);
         *
         *     // 5. grant zap permission to modify an account's collateral
         *     perpsMarket.grantPermission(
         *         accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
         *     );
         *
         *     // 6. add 1000 usdx as collateral
         *     perpsMarket.modifyCollateral(accountId, 0, int128(amount));
         *
         *     // 7. determine debt
         *     uint256 accountDebt = perpsMarket.debt(accountId);
         *
         *     // 8. request flash loan
         *     zap.requestFlashloan({
         *         _usdcLoan: accountDebt,
         *         _collateralAmount: amount,
         *         _collateral: address(usdc),
         *         _accountId: accountId,
         *         _synthId: ARBITRUM_SUSDC_SPOT_MARKET_ID,
         *         _tolerance: DEFAULT_TOLERANCE,
         *         _swapTolerance: DEFAULT_TOLERANCE,
         *         receiver: ARBITRUM_BOB
         *     });
         *
         *     // 9. end bob prank
         *     vm.stopPrank();
         */
    }

}
