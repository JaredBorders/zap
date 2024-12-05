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

import "forge-std/console2.sol";

contract BurnTest is Bootstrap {

    /// @custom:todo
    ///@notice passes at block 269_610_923
    function test_burn_arbitrum(uint32 amount) public arbitrum {
        IERC20 A_USDX = IERC20(ARBITRUM_USDX);
        uint128 accountID = 170_141_183_460_469_231_731_687_303_715_884_105_766;

        address accountOwner = 0x12a41a75793b6ac2cdDAF680798BB461a1024a46;

        uint256 debt = IPerpsMarket(zap.PERPS_MARKET()).debt(accountID);

        vm.assume(amount > 1e6 && amount <= debt);

        uint256 balBefore = A_USDX.balanceOf(accountOwner);

        vm.startPrank(accountOwner);
        A_USDX.approve(address(zap), type(uint256).max);

        zap.burn(amount, accountID);

        uint256 balAfter = A_USDX.balanceOf(accountOwner);
        uint256 debtAfter = IPerpsMarket(zap.PERPS_MARKET()).debt(accountID);

        assertEq(balAfter, balBefore - amount);
        assertEq(debt - amount, debtAfter);
    }

    /// @custom:todo
    function test_burn_base(uint32 amount) public base {}

    /// @custom:todo
    function test_burn_arbitrum_sepolia(uint32 amount)
        public
        arbitrum_sepolia
    {}

}
