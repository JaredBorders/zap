# ISpotMarket
[Git Source](https://github.com/moss-eth/zap/blob/59cf0756a77f382e301eda36c7e1793c595fd9b7/src/interfaces/ISynthetix.sol)


## Functions
### getSynth


```solidity
function getSynth(uint128 marketId)
    external
    view
    returns (address synthAddress);
```

### wrap


```solidity
function wrap(
    uint128 marketId,
    uint256 wrapAmount,
    uint256 minAmountReceived
)
    external
    returns (uint256 amountToMint, Data memory fees);
```

### unwrap


```solidity
function unwrap(
    uint128 marketId,
    uint256 unwrapAmount,
    uint256 minAmountReceived
)
    external
    returns (uint256 returnCollateralAmount, Data memory fees);
```

### buy


```solidity
function buy(
    uint128 marketId,
    uint256 usdAmount,
    uint256 minAmountReceived,
    address referrer
)
    external
    returns (uint256 synthAmount, Data memory fees);
```

### sell


```solidity
function sell(
    uint128 marketId,
    uint256 synthAmount,
    uint256 minUsdAmount,
    address referrer
)
    external
    returns (uint256 usdAmountReceived, Data memory fees);
```

## Structs
### Data

```solidity
struct Data {
    uint256 fixedFees;
    uint256 utilizationFees;
    int256 skewFees;
    int256 wrapperFees;
}
```

