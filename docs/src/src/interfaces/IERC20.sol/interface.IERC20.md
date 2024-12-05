# IERC20
[Git Source](https://github.com/moss-eth/zap/blob/59cf0756a77f382e301eda36c7e1793c595fd9b7/src/interfaces/IERC20.sol)


## Functions
### decimals


```solidity
function decimals() external view returns (uint8);
```

### balanceOf


```solidity
function balanceOf(address account) external view returns (uint256);
```

### allowance


```solidity
function allowance(
    address owner,
    address spender
)
    external
    view
    returns (uint256);
```

### transfer


```solidity
function transfer(address to, uint256 amount) external returns (bool);
```

### approve


```solidity
function approve(address spender, uint256 amount) external returns (bool);
```

### transferFrom


```solidity
function transferFrom(
    address from,
    address to,
    uint256 amount
)
    external
    returns (bool);
```

