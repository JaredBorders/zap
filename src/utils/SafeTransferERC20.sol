// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0)
// (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.20;

import {IERC20} from "../interfaces/IERC20.sol";

/**
 * @title SafeERC20
 * @dev Wrappers around ERC-20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to
 * your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`,
 * etc.
 */
library SafeERC20 {

    /**
     * @dev An operation with an ERC-20 token failed.
     */
    error SafeERC20FailedOperation(address token);

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to
     * `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the
     * approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are
     * assumed to be successful.
     */
    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    )
        internal
    {
        _callOptionalReturn(
            token, abi.encodeCall(token.transferFrom, (from, to, value))
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to
     * a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is
     * returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its
     * variants).
     *
     * This is a variant of {_callOptionalReturnBool} that reverts if call fails
     * to meet the requirements.
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        uint256 returnSize;
        uint256 returnValue;
        assembly ("memory-safe") {
            let success :=
                call(gas(), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            // bubble errors
            if iszero(success) {
                let ptr := mload(0x40)
                returndatacopy(ptr, 0, returndatasize())
                revert(ptr, returndatasize())
            }
            returnSize := returndatasize()
            returnValue := mload(0)
        }

        if (
            returnSize == 0 ? address(token).code.length == 0 : returnValue != 1
        ) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

}
