// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {IERC20} from "./interfaces/IERC20.sol";
import {ISpotMarketProxy} from "./interfaces/ISpotMarketProxy.sol";
import {ZapEvents} from "./ZapEvents.sol";

/// @title Zap contract for wrapping/unwrapping $USDC into $sUSD
/// @author JaredBorders (jaredborders@pm.me)
abstract contract Zap is ZapEvents {
    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice keccak256 hash of expected name of $sUSDC synth
    bytes32 internal constant HASHED_USDC_NAME =
        keccak256(abi.encodePacked("Synthetic USD Coin Spot Market"));

    /*//////////////////////////////////////////////////////////////
                               IMMUTABLES
    //////////////////////////////////////////////////////////////*/

    /// @notice $USDC token contract address
    IERC20 internal immutable USDC;

    /// @notice $sUSD token contract address
    IERC20 internal immutable SUSD;

    /// @notice sUSDC token contract address
    IERC20 internal immutable SUSDC;

    /// @notice Synthetix v3 Spot Market ID for $sUSDC
    uint128 internal immutable SUSDC_SPOT_MARKET_ID;

    /// @notice Synthetix v3 Spot Market Proxy contract address
    ISpotMarketProxy internal immutable SPOT_MARKET_PROXY;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @notice Zap constructor
    /// @dev will revert if any of the addresses are zero
    /// @dev will revert if the Synthetix v3 Spot Market ID for $sUSDC is incorrect
    /// @param _usdc $USDC token contract address
    /// @param _susd $sUSD token contract address
    /// @param _spotMarketProxy Synthetix v3 Spot Market Proxy contract address
    /// @param _sUSDCId Synthetix v3 Spot Market ID for $sUSDC
    constructor(
        address _usdc,
        address _susd,
        address _spotMarketProxy,
        uint128 _sUSDCId
    ) {
        assert(_usdc != address(0));
        assert(_susd != address(0));
        assert(_spotMarketProxy != address(0));

        USDC = IERC20(_usdc);
        SUSD = IERC20(_susd);
        SPOT_MARKET_PROXY = ISpotMarketProxy(_spotMarketProxy);

        assert(
            keccak256(abi.encodePacked(SPOT_MARKET_PROXY.name(_sUSDCId)))
                == HASHED_USDC_NAME
        );

        SUSDC_SPOT_MARKET_ID = _sUSDCId;
        SUSDC = IERC20(SPOT_MARKET_PROXY.getSynth(_sUSDCId));
    }

    /*//////////////////////////////////////////////////////////////
                                 HOOKS
    //////////////////////////////////////////////////////////////*/

    /// @notice hook called immediately prior to executing a zap
    /// @dev only implement if needed
    function _preZap() internal virtual {}

    /// @notice hook called immediately after executing a zap
    /// @dev only implement if needed
    function _postZap() internal virtual {}

    /*//////////////////////////////////////////////////////////////
                                ZAPPING
    //////////////////////////////////////////////////////////////*/

    /// @notice zap wraps/unwraps $USDC into $sUSD
    /// @dev must approve the Zap contract to spend $USDC
    /// @dev assumes zero fees when wrapping/unwrapping/selling/buying
    /// @param _amount is the amount of $USDC to wrap/unwrap
    /// @param _referrer optional address of the referrer, for Synthetix fee share
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
        assert(USDC.transferFrom(msg.sender, address(this), _amount));

        // allocate $USDC allowance to the Spot Market Proxy
        assert(USDC.approve(address(SPOT_MARKET_PROXY), _amount));

        // wrap $USDC into $sUSDC
        /// @dev call will result in $sUSDC minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.wrap({
            marketId: SUSDC_SPOT_MARKET_ID,
            wrapAmount: _amount,
            minAmountReceived: _amount
        });

        // allocate $sUSDC allowance to the Spot Market Proxy
        assert(SUSDC.approve(address(SPOT_MARKET_PROXY), _amount));

        // sell $sUSDC for $sUSD
        /// @dev call will result in $sUSD minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.sell({
            marketId: SUSDC_SPOT_MARKET_ID,
            synthAmount: _amount,
            minUsdAmount: _amount,
            referrer: _referrer
        });

        emit ZappedIn(_amount);
    }

    function _zapOut(uint256 _amount, address _referrer) internal {
        // allocate $sUSD allowance to the Spot Market Proxy
        assert(SUSD.approve(address(SPOT_MARKET_PROXY), _amount));

        // buy $sUSDC with $sUSD
        /// @dev call will result in $sUSDC minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.buy({
            marketId: SUSDC_SPOT_MARKET_ID,
            usdAmount: _amount,
            minAmountReceived: _amount,
            referrer: _referrer
        });

        // allocate $sUSDC allowance to the Spot Market Proxy
        assert(SUSDC.approve(address(SPOT_MARKET_PROXY), _amount));

        // unwrap $sUSDC into $USDC
        /// @dev call will result in $USDC minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.unwrap({
            marketId: SUSDC_SPOT_MARKET_ID,
            unwrapAmount: _amount,
            minAmountReceived: _amount / 1e12
        });

        emit ZappedOut(_amount);
    }
}
