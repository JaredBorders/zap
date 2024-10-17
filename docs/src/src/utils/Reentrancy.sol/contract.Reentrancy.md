# Reentrancy
[Git Source](https://github.com/moss-eth/zap/blob/837dea0ecd01a90cfb6c452fb41dfd93b5be22d4/src/utils/Reentrancy.sol)

**Authors:**
@moss-eth, @jaredborders


## State Variables
### stage
current stage of execution


```solidity
Stage internal stage;
```


## Functions
### requireStage

validate current stage of execution is as expected


```solidity
modifier requireStage(Stage expected);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`expected`|`Stage`|stage of execution|


### _requireStage


```solidity
function _requireStage(Stage _expected) internal view;
```

## Errors
### ReentrancyDetected
thrown when stage of execution is not expected


```solidity
error ReentrancyDetected(Stage actual, Stage expected);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`actual`|`Stage`|current stage of execution|
|`expected`|`Stage`|expected stage of execution|

## Enums
### Stage
enumerated stages of execution

*each stage denotes a different level of protection*


```solidity
enum Stage {
    UNSET,
    LEVEL1,
    LEVEL2
}
```

