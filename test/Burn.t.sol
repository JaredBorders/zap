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

contract BurnTest is Bootstrap {

    /// @custom:todo
    function test_burn_arbitrum_sepolia(uint32 amount)
        public
        arbitrum_sepolia
    {}

}
