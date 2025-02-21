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

contract AaveTest is Bootstrap, Errors {

    /// @custom:disabled no stata on arbitrum
    // function test_executeOperation_only_aave(
    //     address caller,
    //     address a,
    //     uint256 b,
    //     uint256 c,
    //     bytes calldata d
    // )
    //     public
    //     arbitrum
    // {
    //     if (caller != zap.AAVE()) {
    //         vm.prank(caller);
    //         vm.expectRevert(abi.encodeWithSelector(OnlyAave.selector, caller));
    //         zap.executeOperation(a, b, c, a, d);
    //     }
    // }

}
