// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

/// @title Contract for defining constants used in testing
/// @author JaredBorders (jaredborders@pm.me)
contract Constants {
    uint256 public constant BASE_BLOCK_NUMBER = 8_163_000;
    address public constant ACTOR = address(0xAC7AC7AC7);
    address public constant BAD_ACTOR = address(0xBACBACBAC);
    address public constant REFERRER = address(0xFEEEEEEEE);
    uint256 public constant UINT_ONE_HUNDRED = 100 ether;
    int256 public constant INT_ONE_HUNDRED = 100 ether;
    int256 public constant INT_NEGATIVE_ONE_HUNDRED = -100 ether;
}
