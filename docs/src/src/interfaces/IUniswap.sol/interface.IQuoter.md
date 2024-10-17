# IQuoter
[Git Source](https://github.com/moss-eth/zap/blob/837dea0ecd01a90cfb6c452fb41dfd93b5be22d4/src/interfaces/IUniswap.sol)


## Functions
### quoteExactInput

Returns the amount out received for a given exact input swap
without executing the swap


```solidity
function quoteExactInput(
    bytes memory path,
    uint256 amountIn
)
    external
    returns (
        uint256 amountOut,
        uint160[] memory sqrtPriceX96AfterList,
        uint32[] memory initializedTicksCrossedList,
        uint256 gasEstimate
    );
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`path`|`bytes`|The path of the swap, i.e. each token pair and the pool fee|
|`amountIn`|`uint256`|The amount of the first token to swap|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountOut`|`uint256`|The amount of the last token that would be received|
|`sqrtPriceX96AfterList`|`uint160[]`|List of the sqrt price after the swap for each pool in the path|
|`initializedTicksCrossedList`|`uint32[]`|List of the initialized ticks that the swap crossed for each pool in the path|
|`gasEstimate`|`uint256`|The estimate of the gas that the swap consumes|


### quoteExactOutput

Returns the amount in required for a given exact output swap
without executing the swap


```solidity
function quoteExactOutput(
    bytes memory path,
    uint256 amountOut
)
    external
    returns (
        uint256 amountIn,
        uint160[] memory sqrtPriceX96AfterList,
        uint32[] memory initializedTicksCrossedList,
        uint256 gasEstimate
    );
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`path`|`bytes`|The path of the swap, i.e. each token pair and the pool fee. Path must be provided in reverse order|
|`amountOut`|`uint256`|The amount of the last token to receive|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountIn`|`uint256`|The amount of first token required to be paid|
|`sqrtPriceX96AfterList`|`uint160[]`|List of the sqrt price after the swap for each pool in the path|
|`initializedTicksCrossedList`|`uint32[]`|List of the initialized ticks that the swap crossed for each pool in the path|
|`gasEstimate`|`uint256`|The estimate of the gas that the swap consumes|


