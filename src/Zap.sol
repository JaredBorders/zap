// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {IERC20} from "./interfaces/IERC20.sol";
import {ISpotMarketProxy} from "./interfaces/ISpotMarketProxy.sol";
import {ZapErrors} from "./ZapErrors.sol";
import {ZapEvents} from "./ZapEvents.sol";

/// @title Zap contract for wrapping/unwrapping $USDC into $sUSD
/// via Synthetix v3 Andromeda Spot Market
/// @author JaredBorders (jaredborders@pm.me)
abstract contract Zap is ZapErrors, ZapEvents {
    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice keccak256 hash of expected name of $sUSDC synth
    /// @dev pre-computed to save gas during deployment:
    /// keccak256(abi.encodePacked("Synthetic USD Coin Spot Market"))
    bytes32 internal constant HASHED_SUSDC_NAME =
        0xdb59c31a60f6ecfcb2e666ed077a3791b5c753b5a5e8dc5120f29367b94bbb22;

    /*//////////////////////////////////////////////////////////////
                               IMMUTABLES
    //////////////////////////////////////////////////////////////*/

    /// @notice $USDC token contract address
    IERC20 internal immutable USDC;

    /// @notice $sUSD token/synth contract address
    IERC20 internal immutable SUSD;

    /// @notice $sUSDC token/synth contract address
    IERC20 internal immutable SUSDC;

    /// @notice Synthetix v3 Spot Market ID for $sUSDC
    uint128 internal immutable SUSDC_SPOT_MARKET_ID;

    /// @notice Synthetix v3 Spot Market Proxy contract address
    ISpotMarketProxy internal immutable SPOT_MARKET_PROXY;

    /// @notice used to adjust $USDC decimals
    uint256 internal immutable DECIMALS_FACTOR;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @notice Zap constructor
    /// @dev will revert if any of the addresses are zero
    /// @dev will revert if the Synthetix v3 Spot Market ID for
    /// $sUSDC is incorrect
    /// @param _usdc $USDC token contract address
    /// @param _susd $sUSD token contract address
    /// @param _spotMarketProxy Synthetix v3 Spot Market Proxy
    /// contract address
    /// @param _sUSDCId Synthetix v3 Spot Market ID for $sUSDC
    constructor(
        address _usdc,
        address _susd,
        address _spotMarketProxy,
        uint128 _sUSDCId
    ) {
        if (_usdc == address(0)) revert ZeroAddress();
        if (_susd == address(0)) revert ZeroAddress();
        if (_spotMarketProxy == address(0)) revert ZeroAddress();

        USDC = IERC20(_usdc);
        SUSD = IERC20(_susd);
        SPOT_MARKET_PROXY = ISpotMarketProxy(_spotMarketProxy);

        DECIMALS_FACTOR = 10 ** (18 - IERC20(_usdc).decimals());

        if (
            keccak256(abi.encodePacked(SPOT_MARKET_PROXY.name(_sUSDCId)))
                != HASHED_SUSDC_NAME
        ) revert InvalidIdSUSDC(_sUSDCId);

        // id of $sUSDC is verified to be correct via the above
        // name comparison check
        SUSDC_SPOT_MARKET_ID = _sUSDCId;
        SUSDC = IERC20(SPOT_MARKET_PROXY.getSynth(_sUSDCId));
    }

    /*//////////////////////////////////////////////////////////////
                                 HOOKS
    //////////////////////////////////////////////////////////////*/

    /// @notice hook called prior to executing a zap
    /// @dev use hooks with caution; refer to
    /// docs.openzeppelin.com/contracts/3.x/extending-contracts#using-hooks
    /// for more information
    function _preZap() internal virtual {}

    /// @notice hook called after executing a zap
    /// @dev use hooks with caution; refer to
    /// docs.openzeppelin.com/contracts/3.x/extending-contracts#using-hooks
    /// for more information
    function _postZap() internal virtual {}

    /*//////////////////////////////////////////////////////////////
                                ZAPPING
    //////////////////////////////////////////////////////////////*/

    /// @notice zap wraps/unwraps $USDC into/from $sUSD
    /// @dev wrapping $USDC requires sufficient Zap
    /// contract $USDC allowance
    /// and thus is a pure 1:1 ratio
    /// @dev unwrapping may result in a loss of precision:
    /// unwrapping (1e12 + n) $sUSDC results in 1 $USDC
    /// where n is a number less than 1e12
    /// @dev assumes zero fees when
    /// wrapping/unwrapping/selling/buying
    /// @param _amount is the amount of $USDC to wrap/unwrap
    /// @param _referrer optional address of the referrer,
    /// for Synthetix fee share
    function zap(int256 _amount, address _referrer) external {
        _preZap();

        if (_amount > 0) {
            _zapIn(uint256(_amount), _referrer);
        } else {
            _zapOut(uint256(-_amount), _referrer);
        }

        _postZap();
    }

    function _zapIn(uint256 _amount, address _referrer) internal {
        // transfer $USDC to the Zap contract
        if (!USDC.transferFrom(msg.sender, address(this), _amount)) {
            revert TransferFailed(
                address(USDC), msg.sender, address(this), _amount
            );
        }

        // allocate $USDC allowance to the Spot Market Proxy
        if (!USDC.approve(address(SPOT_MARKET_PROXY), _amount)) {
            revert ApprovalFailed(
                address(USDC),
                address(this),
                address(SPOT_MARKET_PROXY),
                _amount
            );
        }

        /// @notice $USDC may use non-standard decimals
        /// @dev adjustedAmount is the amount of $sUSDC
        /// expected to receive from wrapping
        /// @dev Synthetix synths use 18 decimals
        /// @custom:example if $USDC has 6 decimals,
        /// and $sUSD and $sUSDC have 18 decimals,
        /// then, 1e12 $sUSD/$sUSDC = 1 $USDC
        uint256 adjustedAmount = _amount * DECIMALS_FACTOR;

        /// @notice wrap $USDC into $sUSDC
        /// @dev call will result in $sUSDC minted/transferred
        /// to the Zap contract
        SPOT_MARKET_PROXY.wrap({
            marketId: SUSDC_SPOT_MARKET_ID,
            wrapAmount: _amount,
            minAmountReceived: adjustedAmount
        });

        // allocate $sUSDC allowance to the Spot Market Proxy
        if (!SUSDC.approve(address(SPOT_MARKET_PROXY), adjustedAmount)) {
            revert ApprovalFailed(
                address(SUSDC),
                address(this),
                address(SPOT_MARKET_PROXY),
                adjustedAmount
            );
        }

        /// @notice sell $sUSDC for $sUSD
        /// @dev call will result in $sUSD minted/transferred
        /// to the Zap contract
        SPOT_MARKET_PROXY.sell({
            marketId: SUSDC_SPOT_MARKET_ID,
            synthAmount: adjustedAmount,
            minUsdAmount: adjustedAmount,
            referrer: _referrer
        });

        emit ZappedIn(adjustedAmount);
    }

    function _zapOut(uint256 _amount, address _referrer) internal {
        // allocate $sUSD allowance to the Spot Market Proxy
        if (!SUSD.approve(address(SPOT_MARKET_PROXY), _amount)) {
            revert ApprovalFailed(
                address(SUSD),
                address(this),
                address(SPOT_MARKET_PROXY),
                _amount
            );
        }

        /// @notice buy $sUSDC with $sUSD
        /// @dev call will result in $sUSDC minted/transferred
        /// to the Zap contract
        SPOT_MARKET_PROXY.buy({
            marketId: SUSDC_SPOT_MARKET_ID,
            usdAmount: _amount,
            minAmountReceived: _amount,
            referrer: _referrer
        });

        // allocate $sUSDC allowance to the Spot Market Proxy
        if (!SUSDC.approve(address(SPOT_MARKET_PROXY), _amount)) {
            revert ApprovalFailed(
                address(SUSDC),
                address(this),
                address(SPOT_MARKET_PROXY),
                _amount
            );
        }

        /// @notice prior to unwrapping, ensure that there
        /// is enough $sUSDC to unwrap
        /// @custom:example if $USDC has 6 decimals, and
        /// $sUSDC has greater than 6 decimals,
        /// then it is possible that the amount of
        /// $sUSDC to unwrap is less than 1 $USDC;
        /// this contract will prevent such cases
        /// @dev if $USDC has 6 decimals, and $sUSDC has 18 decimals,
        /// precision may be lost
        if (_amount < DECIMALS_FACTOR) {
            revert InsufficientAmount(_amount);
        }

        /// @notice $USDC might use non-standard decimals
        /// @dev adjustedAmount is the amount of $USDC
        /// expected to receive from unwrapping
        /// @custom:example if $USDC has 6 decimals,
        /// and $sUSD and $sUSDC have 18 decimals,
        /// then, 1e12 $sUSD/$sUSDC = 1 $USDC
        uint256 adjustedAmount = _amount / DECIMALS_FACTOR;

        /// @notice unwrap $USDC via burning $sUSDC
        /// @dev call will result in $USDC minted/transferred
        /// to the Zap contract
        SPOT_MARKET_PROXY.unwrap({
            marketId: SUSDC_SPOT_MARKET_ID,
            unwrapAmount: _amount,
            minAmountReceived: adjustedAmount
        });

        emit ZappedOut(adjustedAmount);
    }
}
