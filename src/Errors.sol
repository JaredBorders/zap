// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

/// @title zap errors
/// @author @jaredborders
contract Errors {

    /// @notice thrown when a wrap operation fails
    /// @param reason string for the failure
    error WrapFailed(string reason);

    /// @notice thrown when an unwrap operation fails
    /// @param reason string for the failure
    error UnwrapFailed(string reason);

    /// @notice thrown when a swap operation fails
    /// @param reason string for the failure
    error SwapFailed(string reason);

    /// @notice thrown when an address who is not permitted
    /// to modify an account's collateral attempts to
    error NotPermittedToModifyCollateral();

}
