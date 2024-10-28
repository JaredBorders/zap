# IRouter
[Git Source](https://github.com/moss-eth/zap/blob/633c02e3c1d55b8cd7b9a28033f9517a34a72a75/src/interfaces/IUniswap.sol)


## Functions
### exactInput

Swaps `amountIn` of one token for as much as possible of another
along the specified path


```solidity
function exactInput(ExactInputParams calldata params)
    external
    payable
    returns (uint256 amountOut);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`params`|`ExactInputParams`|The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountOut`|`uint256`|The amount of the received token|


### exactOutput

Swaps as little as possible of one token for `amountOut` of
another along the specified path (reversed)


```solidity
function exactOutput(ExactOutputParams calldata params)
    external
    payable
    returns (uint256 amountIn);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`params`|`ExactOutputParams`|The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountIn`|`uint256`|The amount of the input token|


## Structs
### ExactInputParams

```solidity
struct ExactInputParams {
    bytes path;
    address recipient;
    uint256 amountIn;
    uint256 amountOutMinimum;
}
```

### ExactOutputParams

```solidity
struct ExactOutputParams {
    bytes path;
    address recipient;
    uint256 amountOut;
    uint256 amountInMaximum;
}
```

