// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

/// @title zap enums
/// @author @moss-eth
contract Enums {

    /// @notice multi-level reentrancy guard to protect callback function
    enum MultiLevelReentrancyGuard {
        Unset,
        Level1,
        Level2
    }

}
