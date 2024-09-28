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
    Reentrancy,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

contract ReentrancyTest is Bootstrap, Reentrancy {

    function test_stage_enum_unset() public {
        assertEq(uint256(Stage.UNSET), 0);
    }

    function test_stage_enum_level1() public {
        assertEq(uint256(Stage.LEVEL1), 1);
    }

    function test_stage_enum_level2() public {
        assertEq(uint256(Stage.LEVEL2), 2);
    }

    function test_stage_default() public {
        assertEq(uint256(stage), 0);
    }

    function test_requireStage(uint8 actual) public {
        vm.assume(actual < 3);
        stage = Stage(actual);
        if (actual == 0) {
            _requireStage(Stage.UNSET);
        } else if (actual == 1) {
            _requireStage(Stage.LEVEL1);
        } else if (actual == 2) {
            _requireStage(Stage.LEVEL2);
        }
    }

    function test_requireStage_throws(uint8 actual, uint256 expected) public {
        vm.assume(actual < 3 && expected < 3);
        stage = Stage(actual);
        if (expected != actual) {
            vm.expectRevert(
                abi.encodeWithSelector(
                    ReentrancyDetected.selector, stage, Stage(expected)
                )
            );
            _requireStage(Stage(expected));
        }
    }

}
