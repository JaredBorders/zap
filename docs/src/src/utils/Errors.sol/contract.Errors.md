# Errors
[Git Source](https://github.com/moss-eth/zap/blob/59cf0756a77f382e301eda36c7e1793c595fd9b7/src/utils/Errors.sol)

**Author:**
@jaredborders


## Errors
### WrapFailed
thrown when a wrap operation fails


```solidity
error WrapFailed(string reason);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`reason`|`string`|string for the failure|

### UnwrapFailed
thrown when an unwrap operation fails


```solidity
error UnwrapFailed(string reason);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`reason`|`string`|string for the failure|

### BuyFailed
thrown when a buy operation fails


```solidity
error BuyFailed(string reason);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`reason`|`string`|string for the failure|

### SellFailed
thrown when a sell operation fails


```solidity
error SellFailed(string reason);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`reason`|`string`|string for the failure|

### SwapFailed
thrown when a swap operation fails


```solidity
error SwapFailed();
```

### NotPermitted
thrown when operation is not permitted


```solidity
error NotPermitted();
```

### ReentrancyGuardReentrantCall
Unauthorized reentrant call.


```solidity
error ReentrancyGuardReentrantCall();
```

### PullFailed
thrown when a pull operation fails


```solidity
error PullFailed(bytes reason);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`reason`|`bytes`|data for the failure|

### PushFailed
thrown when a push operation fails


```solidity
error PushFailed(bytes reason);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`reason`|`bytes`|data for the failure|

### OnlyAave
thrown when caller is not Aave pool address


```solidity
error OnlyAave(address caller);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`|address of the msg.sender|

