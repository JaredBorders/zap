// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

/// @title Zap contract errors
/// @author JaredBorders (jaredborders@pm.me)
contract ZapErrors {

    /// @notice Thrown when a wrap operation fails
    /// @param reason The reason for the failure
    error WrapFailed(string reason);

    /// @notice Thrown when an unwrap operation fails
    /// @param reason The reason for the failure
    error UnwrapFailed(string reason);

    /// @notice Thrown when a swap operation fails
    /// @param reason The reason for the failure
    error SwapFailed(string reason);

}
