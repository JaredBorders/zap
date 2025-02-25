# IPerpsMarket
[Git Source](https://github.com/moss-eth/zap/blob/59cf0756a77f382e301eda36c7e1793c595fd9b7/src/interfaces/ISynthetix.sol)


## Functions
### modifyCollateral


```solidity
function modifyCollateral(
    uint128 accountId,
    uint128 synthMarketId,
    int256 amountDelta
)
    external;
```

### renouncePermission


```solidity
function renouncePermission(uint128 accountId, bytes32 permission) external;
```

### isAuthorized


```solidity
function isAuthorized(
    uint128 accountId,
    bytes32 permission,
    address target
)
    external
    view
    returns (bool isAuthorized);
```

### payDebt


```solidity
function payDebt(uint128 accountId, uint256 amount) external;
```

### debt


```solidity
function debt(uint128 accountId) external view returns (uint256 accountDebt);
```

