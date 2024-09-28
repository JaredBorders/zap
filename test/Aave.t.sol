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

contract AaveTest is Bootstrap, Errors {

    function test_only_aave_arbitrum(
        address caller,
        address a,
        uint256 b,
        uint256 c,
        bytes calldata d
    )
        public
        arbitrum
    {
        if (caller != zap.AAVE()) {
            vm.prank(caller);
            vm.expectRevert(abi.encodeWithSelector(OnlyAave.selector, caller));
            zap.executeOperation(a, b, c, a, d);
        }
    }

    function test_only_aave_base(
        address caller,
        address a,
        uint256 b,
        uint256 c,
        bytes calldata d
    )
        public
        base
    {
        if (caller != zap.AAVE()) {
            vm.prank(caller);
            vm.expectRevert(abi.encodeWithSelector(OnlyAave.selector, caller));
            zap.executeOperation(a, b, c, a, d);
        }
    }

}
