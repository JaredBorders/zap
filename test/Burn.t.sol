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

import {console} from "forge-std/Console.sol";

contract BurnTest is Bootstrap {

    /// @custom:todo
    function test_burn_arbitrum_sepolia(uint32 amount)
        public
        arbitrum_sepolia
    {
        uint32 amount = 1_000_000_000;
        _spin(ACTOR, usdx, amount, address(zap));

        vm.startPrank(ACTOR);
        uint128 accountId = perpsMarket.createAccount();
        int128 margin = int128(int32(amount));
        usdx.approve(address(perpsMarket), type(uint256).max);
        usdx.approve(address(spotMarket), type(uint256).max);
        perpsMarket.grantPermission(
            accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
        );
        perpsMarket.modifyCollateral(accountId, 0, margin);

        // spotMarket.wrap(zap.SUSDC_SPOT_ID(), 1, 0);
        // spotMarket.buy(zap.SUSDC_SPOT_ID(), 1, 0, address(0));

        //TODO, theres no debt, but cannot buy synths either do to stale oracle price feed

        zap.burn(amount, accountId);
    }

}
