# IERC4626
[Git Source](https://github.com/moss-eth/zap/blob/7ecc5cc79642d99fe6248a4895ed17a8ea025990/src/interfaces/IERC4626.sol)


## Functions
### approve


```solidity
function approve(address spender, uint256 amount) external returns (bool);
```

### deposit


```solidity
function deposit(
    uint256 assets,
    address receiver
)
    external
    returns (uint256 shares);
```

### redeem


```solidity
function redeem(
    uint256 shares,
    address receiver,
    address owner
)
    external
    returns (uint256 assets);
```

