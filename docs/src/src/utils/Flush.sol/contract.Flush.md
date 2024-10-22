# Flush
[Git Source](https://github.com/moss-eth/zap/blob/70d3ea131ffe8af2f978b53f91daa0d8ac74d19a/src/utils/Flush.sol)

**Author:**
@jaredborders


## State Variables
### PLUMBER

```solidity
address public PLUMBER;
```


## Functions
### constructor


```solidity
constructor(address _plumber);
```

### flush

flush dust out of the contract


```solidity
function flush(address _token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|address of token to flush|


### designatePlumber

designate a new plumber

*zero address can be used to remove flush capability*


```solidity
function designatePlumber(address _newPlumber) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newPlumber`|`address`|address of new plumber|


## Events
### PlumberDesignated
emitted when a new plumber is designated


```solidity
event PlumberDesignated(address plumber);
```

## Errors
### OnlyPlumber
thrown when caller is not the plumber


```solidity
error OnlyPlumber();
```

