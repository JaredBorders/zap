// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title Kwenta Example Contract
/// @notice Responsible for counting
/// @author JaredBorders (jaredborders@pm.me)
contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
