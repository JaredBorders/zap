// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {IERC20} from "./interfaces/IERC20.sol";
import {ISpotMarketProxy} from "./interfaces/ISpotMarketProxy.sol";

/// @title Zap contract for wrapping/unwrapping $USDC into $sUSD
/// @author JaredBorders (jaredborders@pm.me)
abstract contract Zap {
    /// @notice keccak256 hash of expected name of $sUSDC synth
    bytes32 internal constant HASHED_USDC_NAME =
        keccak256(abi.encodePacked("Synthetic USD Coin Spot Market"));

    /// @notice $USDC token contract address
    IERC20 internal immutable USDC;

    /// @notice $sUSD token contract address
    IERC20 internal immutable SUSD;

    /// @notice Synthetix v3 Spot Market Proxy contract address
    ISpotMarketProxy internal immutable SPOT_MARKET_PROXY;

    /// @notice ZapDetails struct defines the details
    /// of the $USDC <-> $sUSD exchange
    struct ZapDetails {
        /// @notice sUSDCMarketId is the marketId of the $sUSDC synth
        /// @dev incorrect $sUSDC marketId will result in revert
        uint128 sUSDCMarketId;
        /// @notice amount is the amount of $USDC to wrap/unwrap
        int256 amount;
        /// @notice referrer is the address used to collect
        /// unspecified allocation of fees
        /// @dev the exchange defined in zap will not result
        /// in any fees so this is not used
        address referrer;
    }

    /// @notice Zap constructor
    /// @dev will revert if any of the addresses are zero
    /// @param _usdc $USDC token contract address
    /// @param _susd $sUSD token contract address
    /// @param _spotMarketProxy Synthetix v3 Spot Market Proxy contract address
    constructor(address _usdc, address _susd, address _spotMarketProxy) {
        assert(_usdc != address(0));
        assert(_susd != address(0));
        assert(_spotMarketProxy != address(0));

        USDC = IERC20(_usdc);
        SUSD = IERC20(_susd);
        SPOT_MARKET_PROXY = ISpotMarketProxy(_spotMarketProxy);
    }

    /// @notice withdraws $USDC from the Zap contract
    /// @param _to address to withdraw $USDC to
    function withdrawUSDC(address _to) external virtual {}

    /// @notice withdraws $sUSD from the Zap contract
    /// @param _to address to withdraw $sUSD to
    function withdrawSUSD(address _to) external virtual {}

    /// @notice must approve the Zap contract to spend $USDC
    /// @dev assumes zero fees when wrapping/unwrapping/selling/buying
    /// @param _details ZapDetails struct defines the _details of the $USDC <-> $sUSD exchange
    function zap(ZapDetails calldata _details) external {
        // verify sUSDCMarketId
        _verifySynthMarketId(_details.sUSDCMarketId, HASHED_USDC_NAME);

        // define $sUSDC synth contract
        IERC20 sUSDC =
            IERC20(SPOT_MARKET_PROXY.getSynth(_details.sUSDCMarketId));

        if (_details.amount > 0) {
            _zapIn(
                sUSDC,
                _details.sUSDCMarketId,
                uint256(_details.amount),
                _details.referrer
            );
        } else {
            _zapOut(
                sUSDC,
                _details.sUSDCMarketId,
                uint256(-_details.amount),
                _details.referrer
            );
        }
    }

    function _zapIn(
        IERC20 _sUSDC,
        uint128 _sUSDCMarketId,
        uint256 _amount,
        address _referrer
    ) internal {
        // transfer $USDC to the Zap contract
        assert(USDC.transferFrom(msg.sender, address(this), _amount));

        // allocate $USDC allowance to the Spot Market Proxy
        assert(USDC.approve(address(SPOT_MARKET_PROXY), _amount));

        // wrap $USDC into $sUSDC
        /// @dev call will result in $sUSDC minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.wrap({
            marketId: _sUSDCMarketId,
            wrapAmount: _amount,
            minAmountReceived: _amount
        });

        // allocate $sUSDC allowance to the Spot Market Proxy
        assert(_sUSDC.approve(address(SPOT_MARKET_PROXY), _amount));

        // sell $sUSDC for $sUSD
        /// @dev call will result in $sUSD minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.sell({
            marketId: _sUSDCMarketId,
            synthAmount: _amount,
            minUsdAmount: _amount,
            referrer: _referrer
        });
    }

    function _zapOut(
        IERC20 _sUSDC,
        uint128 _sUSDCMarketId,
        uint256 _amount,
        address _referrer
    ) internal {
        // allocate $sUSD allowance to the Spot Market Proxy
        assert(SUSD.approve(address(SPOT_MARKET_PROXY), _amount));

        // buy $sUSDC with $sUSD
        /// @dev call will result in $sUSDC minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.buy({
            marketId: _sUSDCMarketId,
            usdAmount: _amount,
            minAmountReceived: _amount,
            referrer: _referrer
        });

        // allocate $sUSDC allowance to the Spot Market Proxy
        assert(_sUSDC.approve(address(SPOT_MARKET_PROXY), _amount));

        // unwrap $sUSDC into $USDC
        /// @dev call will result in $USDC minted/transferred to the Zap contract
        SPOT_MARKET_PROXY.unwrap({
            marketId: _sUSDCMarketId,
            unwrapAmount: _amount,
            minAmountReceived: _amount
        });
    }

    function _verifySynthMarketId(uint128 _synthMarketId, bytes32 _hash)
        internal
        view
    {
        string memory retName = SPOT_MARKET_PROXY.name(_synthMarketId);
        assert(keccak256(abi.encodePacked(retName)) == _hash);
    }
}
