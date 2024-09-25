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

    function test_burn_arbitrum(uint32 amount) public {
        /// @custom:todo arbitrum sepolia fork required
    }

}