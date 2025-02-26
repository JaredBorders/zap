# Zap
[Git Source](https://github.com/moss-eth/zap/blob/59cf0756a77f382e301eda36c7e1793c595fd9b7/src/Zap.sol)

**Inherits:**
[Reentrancy](/src/utils/Reentrancy.sol/contract.Reentrancy.md), [Errors](/src/utils/Errors.sol/contract.Errors.md), [Flush](/src/utils/Flush.sol/contract.Flush.md)

**Authors:**
@jaredborders, @flocqst, @barrasso, @moss-eth

*idle token balances are not safe*

*intended for standalone use; do not inherit*


## State Variables
### USDC

```solidity
address public immutable USDC;
```


### MODIFY_PERMISSION

```solidity
bytes32 public constant MODIFY_PERMISSION = "PERPS_MODIFY_COLLATERAL";
```


### BURN_PERMISSION

```solidity
bytes32 public constant BURN_PERMISSION = "BURN";
```


### USDX_ID

```solidity
uint128 public immutable USDX_ID;
```


### USDX

```solidity
address public immutable USDX;
```


### SPOT_MARKET

```solidity
address public immutable SPOT_MARKET;
```


### PERPS_MARKET

```solidity
address public immutable PERPS_MARKET;
```


### REFERRER

```solidity
address public immutable REFERRER;
```


### SUSDC_SPOT_ID

```solidity
uint128 public immutable SUSDC_SPOT_ID;
```


### REFERRAL_CODE

```solidity
uint16 public constant REFERRAL_CODE = 0;
```


### AAVE

```solidity
address public immutable AAVE;
```


### ROUTER

```solidity
address public immutable ROUTER;
```


## Functions
### constructor


```solidity
constructor(
    address _usdc,
    address _usdx,
    address _spotMarket,
    address _perpsMarket,
    address _referrer,
    uint128 _susdcSpotId,
    address _aave,
    address _router
);
```

### isAuthorized

validate caller is authorized to modify synthetix perp position


```solidity
modifier isAuthorized(uint128 _accountId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_accountId`|`uint128`|synthetix perp market account id|


### onlyAave

validate caller is Aave lending pool


```solidity
modifier onlyAave();
```

### zapIn

zap USDC into USDx

*caller must grant USDC allowance to this contract*


```solidity
function zapIn(
    uint256 _amount,
    uint256 _minAmountOut,
    address _receiver
)
    external
    returns (uint256 zapped);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|amount of USDC to zap|
|`_minAmountOut`|`uint256`|acceptable slippage for wrapping and selling|
|`_receiver`|`address`|address to receive USDx|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`zapped`|`uint256`|amount of USDx received|


### _zapIn

*allowance is assumed*

*following execution, this contract will hold the zapped USDx*


```solidity
function _zapIn(
    uint256 _amount,
    uint256 _minAmountOut
)
    internal
    returns (uint256 zapped);
```

### zapOut

zap USDx into USDC

*caller must grant USDx allowance to this contract*


```solidity
function zapOut(
    uint256 _amount,
    uint256 _minAmountOut,
    address _receiver
)
    external
    returns (uint256 zapped);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|amount of USDx to zap|
|`_minAmountOut`|`uint256`|acceptable slippage for buying and unwrapping|
|`_receiver`|`address`|address to receive USDC|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`zapped`|`uint256`|amount of USDC received|


### _zapOut

*allowance is assumed*

*following execution, this contract will hold the zapped USDC*


```solidity
function _zapOut(
    uint256 _amount,
    uint256 _minAmountOut
)
    internal
    returns (uint256 zapped);
```

### wrap

wrap collateral via synthetix spot market

*caller must grant token allowance to this contract*


```solidity
function wrap(
    address _token,
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut,
    address _receiver
)
    external
    returns (uint256 wrapped);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|address of token to wrap|
|`_synthId`|`uint128`|synthetix market id of synth to wrap into|
|`_amount`|`uint256`|amount of token to wrap|
|`_minAmountOut`|`uint256`|acceptable slippage for wrapping|
|`_receiver`|`address`|address to receive wrapped synth|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`wrapped`|`uint256`|amount of synth received|


### _wrap

*allowance is assumed*

*following execution, this contract will hold the wrapped synth*


```solidity
function _wrap(
    address _token,
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut
)
    internal
    returns (uint256 wrapped);
```

### unwrap

unwrap collateral via synthetix spot market

*caller must grant synth allowance to this contract*


```solidity
function unwrap(
    address _token,
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut,
    address _receiver
)
    external
    returns (uint256 unwrapped);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|address of token to unwrap into|
|`_synthId`|`uint128`|synthetix market id of synth to unwrap|
|`_amount`|`uint256`|amount of synth to unwrap|
|`_minAmountOut`|`uint256`|acceptable slippage for unwrapping|
|`_receiver`|`address`|address to receive unwrapped token|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`unwrapped`|`uint256`|amount of token received|


### _unwrap

*allowance is assumed*

*following execution, this contract will hold the unwrapped token*


```solidity
function _unwrap(
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut
)
    private
    returns (uint256 unwrapped);
```

### buy

buy synth via synthetix spot market

*caller must grant USDX allowance to this contract*


```solidity
function buy(
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut,
    address _receiver
)
    external
    returns (uint256 received, address synth);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_synthId`|`uint128`|synthetix market id of synth to buy|
|`_amount`|`uint256`|amount of USDX to spend|
|`_minAmountOut`|`uint256`|acceptable slippage for buying|
|`_receiver`|`address`|address to receive synth|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`received`|`uint256`|amount of synth|
|`synth`|`address`||


### _buy

*allowance is assumed*

*following execution, this contract will hold the bought synth*


```solidity
function _buy(
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut
)
    internal
    returns (uint256 received);
```

### sell

sell synth via synthetix spot market

*caller must grant synth allowance to this contract*


```solidity
function sell(
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut,
    address _receiver
)
    external
    returns (uint256 received);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_synthId`|`uint128`|synthetix market id of synth to sell|
|`_amount`|`uint256`|amount of synth to sell|
|`_minAmountOut`|`uint256`|acceptable slippage for selling|
|`_receiver`|`address`|address to receive USDX|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`received`|`uint256`|amount of USDX|


### _sell

*allowance is assumed*

*following execution, this contract will hold the sold USDX*


```solidity
function _sell(
    uint128 _synthId,
    uint256 _amount,
    uint256 _minAmountOut
)
    internal
    returns (uint256 received);
```

### unwind

unwind synthetix perp position collateral

*caller must grant USDC allowance to this contract*


```solidity
function unwind(
    uint128 _accountId,
    uint128 _collateralId,
    uint256 _collateralAmount,
    address _collateral,
    bytes memory _path,
    uint256 _zapMinAmountOut,
    uint256 _unwrapMinAmountOut,
    uint256 _swapAmountIn,
    address _receiver
)
    external
    isAuthorized(_accountId)
    requireStage(Stage.UNSET);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_accountId`|`uint128`|synthetix perp market account id|
|`_collateralId`|`uint128`|synthetix market id of collateral|
|`_collateralAmount`|`uint256`|amount of collateral to unwind|
|`_collateral`|`address`|address of collateral to unwind|
|`_path`|`bytes`|odos path from the sor/assemble api endpoint|
|`_zapMinAmountOut`|`uint256`|acceptable slippage for zapping|
|`_unwrapMinAmountOut`|`uint256`|acceptable slippage for unwrapping|
|`_swapAmountIn`|`uint256`|acceptable slippage for swapping|
|`_receiver`|`address`|address to receive unwound collateral|


### executeOperation

flashloan callback function

*caller must be the Aave lending pool*


```solidity
function executeOperation(
    address,
    uint256 _flashloan,
    uint256 _premium,
    address,
    bytes calldata _params
)
    external
    onlyAave
    requireStage(Stage.LEVEL1)
    returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`||
|`_flashloan`|`uint256`|amount of USDC flashloaned from Aave|
|`_premium`|`uint256`|amount of USDC premium owed to Aave|
|`<none>`|`address`||
|`_params`|`bytes`|encoded parameters for unwinding synthetix perp position|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool representing successful execution|


### _unwind

*unwinds synthetix perp position collateral*


```solidity
function _unwind(
    uint256 _flashloan,
    uint256 _premium,
    bytes calldata _params
)
    internal
    requireStage(Stage.LEVEL2)
    returns (uint256 unwound);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_flashloan`|`uint256`|amount of USDC flashloaned from Aave|
|`_premium`|`uint256`|amount of USDC premium owed to Aave|
|`_params`|`bytes`|encoded parameters for unwinding synthetix perp position|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`unwound`|`uint256`|amount of collateral|


### _approximateLoanNeeded

the path and max amount in must take into consideration:
(1) Aave flashloan amount
(2) premium owed to Aave for flashloan
(3) USDC buffer added to the approximate loan needed

approximate USDC needed to unwind synthetix perp position

*given the USDC buffer, an amount of USDx
necessarily less than the buffer will remain (<$1);
this amount is captured by the protocol*

*(1) is a function of (3); buffer added to loan requested*

*(2) is a function of (1); premium is a percentage of loan*


```solidity
function _approximateLoanNeeded(uint128 _accountId)
    internal
    view
    returns (uint256 amount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_accountId`|`uint128`|synthetix perp market account id|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|of USDC needed|


### burn

burn USDx to pay off synthetix perp position debt

*scale loan amount accordingly*

*barring exceptional circumstances,
a 1 USD buffer is sufficient to circumvent
precision loss*

*caller must grant USDX allowance to this contract*

*excess USDx will be returned to the caller*


```solidity
function burn(
    uint256 _amount,
    uint128 _accountId
)
    external
    returns (uint256 excess);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|amount of USDx to burn|
|`_accountId`|`uint128`|synthetix perp market account id|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`excess`|`uint256`|amount of USDx returned to the caller|


### _burn

*allowance is assumed*

*following execution, this contract will hold any excess USDx*


```solidity
function _burn(uint256 _amount, uint128 _accountId) internal;
```

### withdraw

withdraw collateral from synthetix perp position


```solidity
function withdraw(
    uint128 _synthId,
    uint256 _amount,
    uint128 _accountId,
    address _receiver
)
    external
    isAuthorized(_accountId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_synthId`|`uint128`|synthetix market id of collateral|
|`_amount`|`uint256`|amount of collateral to withdraw|
|`_accountId`|`uint128`|synthetix perp market account id|
|`_receiver`|`address`|address to receive collateral|


### _withdraw

*following execution, this contract will hold the withdrawn
collateral*


```solidity
function _withdraw(
    uint128 _synthId,
    uint256 _amount,
    uint128 _accountId
)
    internal;
```

### swapFrom

swap an amount of tokens for the optimal amount of USDC

*_path USDC is not enforced as the output token during the swap, but
is the expected in the call to push*

*caller must grant token allowance to this contract*


```solidity
function swapFrom(
    address _from,
    bytes memory _path,
    uint256 _amountIn,
    address _receiver
)
    external
    returns (uint256 amountOut);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_from`|`address`|address of token to swap|
|`_path`|`bytes`|odos path from the sor/assemble api endpoint|
|`_amountIn`|`uint256`|amount of token to spend|
|`_receiver`|`address`|address to receive USDC|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountOut`|`uint256`|amount of tokens swapped for|


### odosSwap

*following execution, this contract will hold the swapped USDC*


```solidity
function odosSwap(
    address _tokenFrom,
    uint256 _amountIn,
    bytes memory _swapPath
)
    internal
    returns (uint256 amountOut);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_tokenFrom`|`address`|address of token being swapped|
|`_amountIn`|`uint256`|amount of token being swapped|
|`_swapPath`|`bytes`|bytes from odos assemble api containing the swap details|


### _pull

*pull tokens from a sender*


```solidity
function _pull(address _token, address _from, uint256 _amount) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|address of token to pull|
|`_from`|`address`|address of sender|
|`_amount`|`uint256`|amount of token to pull|


### _push

*push tokens to a receiver*


```solidity
function _push(address _token, address _receiver, uint256 _amount) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|address of token to push|
|`_receiver`|`address`|address of receiver|
|`_amount`|`uint256`|amount of token to push|


