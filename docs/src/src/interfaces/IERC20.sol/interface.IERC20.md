# IERC20
[Git Source](https://github.com/moss-eth/zap/blob/35e517eceade43560c1eb54d47de1fc3aa949331/src/interfaces/IERC20.sol)


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

