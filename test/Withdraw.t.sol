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

contract WithdrawTest is Bootstrap {

    function test_withdraw_base() public base {
        uint32 amount = 1_000_000_000;
        _spin(ACTOR, usdx, amount, address(zap));
        vm.startPrank(ACTOR);
        uint128 accountId = perpsMarket.createAccount();
        int128 margin = int128(int32(amount));
        usdx.approve(address(perpsMarket), type(uint256).max);
        perpsMarket.grantPermission(
            accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
        );
        perpsMarket.modifyCollateral(accountId, 0, margin);
        assertEq(usdx.balanceOf(ACTOR), 0);
        zap.withdraw({
            _synthId: 0,
            _amount: amount,
            _accountId: accountId,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertEq(usdx.balanceOf(ACTOR), amount);
    }

    function test_withdraw_arbitrum() public arbitrum {
        uint32 amount = 1_000_000_000;
        _spin(ACTOR, usdx, amount, address(zap));
        vm.startPrank(ACTOR);
        uint128 accountId = perpsMarket.createAccount();
        int128 margin = int128(int32(amount));
        usdx.approve(address(perpsMarket), type(uint256).max);
        perpsMarket.grantPermission(
            accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
        );
        perpsMarket.modifyCollateral(accountId, 0, margin);
        assertEq(usdx.balanceOf(ACTOR), 0);
        zap.withdraw({
            _synthId: 0,
            _amount: amount,
            _accountId: accountId,
            _receiver: ACTOR
        });
        vm.stopPrank();
        assertEq(usdx.balanceOf(ACTOR), amount);
    }

}
