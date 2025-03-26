# Flush
[Git Source](https://github.com/moss-eth/zap/blob/7ecc5cc79642d99fe6248a4895ed17a8ea025990/src/utils/Flush.sol)

**Author:**
@jaredborders


## State Variables
### PLUMBER
**Note:**
plumber: 


```solidity
address public PLUMBER;
```


### nominatedPlumber

```solidity
address public nominatedPlumber;
```


## Functions
### constructor


```solidity
constructor(address _plumber);
```

### flush

flush dust out of the contract

**Note:**
plumber: is the only authorized caller


```solidity
function flush(address _token) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|address of token to flush|


### nominatePlumber

nominate a new plumber

*zero address can be used to remove flush capability*

**Note:**
plumber: is the only authorized caller


```solidity
function nominatePlumber(address _newPlumber) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newPlumber`|`address`|address of new plumber|


### acceptPlumberNomination


```solidity
function acceptPlumberNomination() external;
```

## Events
### PlumberNominated
emitted when a new plumber is nominated


```solidity
event PlumberNominated(address plumber);
```

### PlumberNominationAccepted
emitted when a new plumber accepts nomination


```solidity
event PlumberNominationAccepted(address plumber);
```

## Errors
### OnlyPlumber
thrown when caller is not the plumber


```solidity
error OnlyPlumber();
```

### OnlyNominatedPlumber
thrown when caller is not nominated to be plumber


```solidity
error OnlyNominatedPlumber();
```

