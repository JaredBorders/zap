# SafeERC20
[Git Source](https://github.com/moss-eth/zap/blob/061fdc888af929a33bd6199e327f88f4440e3090/src/utils/SafeTransferERC20.sol)

*Wrappers around ERC-20 operations that throw on failure (when the token
contract returns false). Tokens that return no value (and instead revert or
throw on failure) are also supported, non-reverting calls are assumed to be
successful.
To use this library you can add a `using SafeERC20 for IERC20;` statement to
your contract,
which allows you to call the safe operations as `token.safeTransfer(...)`,
etc.*


## Functions
### safeTransfer

*Transfer `value` amount of `token` from the calling contract to
`to`. If `token` returns no value,
non-reverting calls are assumed to be successful.*


```solidity
function safeTransfer(IERC20 token, address to, uint256 value) internal;
```

### safeTransferFrom

*Transfer `value` amount of `token` from `from` to `to`, spending the
approval given by `from` to the
calling contract. If `token` returns no value, non-reverting calls are
assumed to be successful.*


```solidity
function safeTransferFrom(
    IERC20 token,
    address from,
    address to,
    uint256 value
)
    internal;
```

### _callOptionalReturn

*Imitates a Solidity high-level call (i.e. a regular function call to
a contract), relaxing the requirement
on the return value: the return value is optional (but if data is
returned, it must not be false).*


```solidity
function _callOptionalReturn(IERC20 token, bytes memory data) private;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`IERC20`|The token targeted by the call.|
|`data`|`bytes`|The call data (encoded using abi.encode or one of its variants). This is a variant of {_callOptionalReturnBool} that reverts if call fails to meet the requirements.|


## Errors
### SafeERC20FailedOperation
*An operation with an ERC-20 token failed.*


```solidity
error SafeERC20FailedOperation(address token);
```

