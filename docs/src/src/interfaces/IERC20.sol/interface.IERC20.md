# IERC20
[Git Source](https://github.com/moss-eth/zap/blob/70d3ea131ffe8af2f978b53f91daa0d8ac74d19a/src/interfaces/IERC20.sol)


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

