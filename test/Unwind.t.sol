// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    Errors,
    ICore,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

contract UnwindTest is Bootstrap, Errors {

    function test_unwind_is_authorized_arbitrum() public arbitrum {
        vm.prank(ACTOR);
        vm.expectRevert(NotPermitted.selector);
        zap.unwind(0, 0, 0, 0, 0, 0, address(0));
    }

    function test_unwind_is_authorized_base() public base {
        vm.prank(ACTOR);
        vm.expectRevert(NotPermitted.selector);
        zap.unwind(0, 0, 0, 0, 0, 0, address(0));
    }

    /// @custom:todo
    function test_unwind_arbitrum_sepolia() public {}

    /// @custom:todo
    function test_unwind_arbitrum() public {}

}
