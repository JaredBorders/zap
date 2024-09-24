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

contract BurnTest is Bootstrap {

    function test_burn_arbitrum(uint32 amount) public arbitrum {
        vm.rollFork(ARBITRUM_FORK_BLOCK_DEBT);
        _spin(ARBITRUM_BOB, usdx, amount, address(zap));
        vm.startPrank(ARBITRUM_BOB);
        core.grantPermission(ARBITRUM_BOB_ID, _BURN_PERMISSION, address(zap));
        zap.burn({_amount: amount, _accountId: ARBITRUM_BOB_ID});
        vm.stopPrank();
    }

}
