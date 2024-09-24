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

    /// @custom:todo
    function test_flash_arbitrum(uint32 amount) public arbitrum {
        vm.rollFork(ARBITRUM_FORK_BLOCK_DEBT);
        _spin(ARBITRUM_BOB, usdx, amount, address(zap));
        vm.startPrank(ARBITRUM_BOB);

        // 1. create perp market account

        // 2. approve usdx to perp market

        // 3. grant zap permission to modify collateral

        // 4. modify collateral; add margin

        // 5. request flash loan

        vm.stopPrank();
    }

}
