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

contract UnwindTest is Bootstrap, Errors {

    function test_unwind_is_authorized() public arbitrum {
        vm.prank(ACTOR);
        vm.expectRevert(NotPermitted.selector);
        zap.unwind(0, 0, 0, address(0), 0, 0, 0, address(0));
    }

    /// @custom:todo
    function test_unwind_arbitrum_sepolia() public arbitrum_sepolia {}

}
