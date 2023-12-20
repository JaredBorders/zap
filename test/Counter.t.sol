// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Bootstrap} from "test/utils/Bootstrap.sol";

contract CounterTest is Bootstrap {
    function setUp() public {
        /// @dev uncomment the following line to test in a forked environment
        /// at a specific block number
        // vm.rollFork(NETWORK_BLOCK_NUMBER);

        initializeOptimismGoerli();
    }
}

contract Increment is CounterTest {
    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }
}

contract SetNumber is CounterTest {
    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
