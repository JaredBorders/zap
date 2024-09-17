// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {ZapErrors} from "./ZapErrors.sol";
import {ZapEvents} from "./ZapEvents.sol";
import {IERC20} from "./interfaces/IERC20.sol";
import {ISpotMarketProxy} from "./interfaces/ISpotMarketProxy.sol";

/// @title Zap contract for zapping collateral in/out of Synthetix v3
/// @author JaredBorders (jaredborders@pm.me)
contract Zap is ZapErrors, ZapEvents {

    /**
     * 2. Errors
     *          - Unsupported market
     *          - Unsupported collateral
     *          - Try-Catch Pattern
     *     4. Tests
     */

    /// @notice Constant for the USD spot market ID
    uint128 internal constant USD_SPOT_MARKET_ID = 0;

    /// @notice Enum to specify the direction of the zap operation
    /// @dev In: Collateral to sUSD, Out: sUSD to Collateral
    enum Direction {
        In,
        Out
    }

    /// @notice Struct to define tolerance levels for wrap and swap operations
    /// @param tolerableWrapAmount Minimum acceptable amount for wrap/unwrap
    /// operations
    /// @param tolerableSwapAmount Minimum acceptable amount for swap operations
    struct Tolerance {
        uint256 tolerableWrapAmount;
        uint256 tolerableSwapAmount;
    }

    /// @notice Struct containing all necessary data for a zap operation
    /// @param spotMarket Address of the spot market proxy contract
    /// @param collateral Address of the collateral token
    /// @param marketId ID of the target market
    /// @param amount Amount of tokens to zap
    /// @param tolerance Tolerance struct for minimum acceptable amounts
    /// @param direction Direction of the zap (In or Out)
    /// @param receiver Address to receive the output tokens
    /// @param referrer Address of the referrer
    struct ZapData {
        ISpotMarketProxy spotMarket;
        IERC20 collateral;
        uint128 marketId;
        uint256 amount;
        Tolerance tolerance;
        Direction direction;
        address receiver;
        address referrer;
    }

    /// @notice Main function to perform a zap operation
    /// @param _data ZapData struct containing all necessary information
    function zap(ZapData calldata _data) external {
        _data.direction == Direction.In ? _zapIn(_data) : _zapOut(_data);
    }

    /// @notice Internal function to perform a zap-in operation (Collateral to
    /// sUSD)
    /// @param _data ZapData struct containing all necessary information
    function _zapIn(ZapData calldata _data) private {
        uint256 amount = _data.amount;

        _data.collateral.transferFrom(msg.sender, address(this), amount);
        _data.collateral.approve(address(_data.spotMarket), amount);

        try _data.spotMarket.wrap({
            marketId: _data.marketId,
            wrapAmount: amount,
            minAmountReceived: _data.tolerance.tolerableWrapAmount
        }) returns (uint256 amountToMint, ISpotMarketProxy.Data memory) {
            amount = amountToMint;
        } catch Error(string memory reason) {
            revert WrapFailed(reason);
        }

        IERC20 synth = IERC20(_data.spotMarket.getSynth(_data.marketId));
        synth.approve(address(_data.spotMarket), amount);

        try _data.spotMarket.sell({
            marketId: _data.marketId,
            synthAmount: amount,
            minUsdAmount: _data.tolerance.tolerableSwapAmount,
            referrer: _data.referrer
        }) returns (uint256 usdAmountReceived, ISpotMarketProxy.Data memory) {
            amount = usdAmountReceived;
        } catch Error(string memory reason) {
            revert SwapFailed(reason);
        }

        IERC20 sUSD = IERC20(_data.spotMarket.getSynth(USD_SPOT_MARKET_ID));
        sUSD.transfer(_data.receiver, amount);

        emit ZapIn(
            msg.sender, _data.marketId, _data.amount, amount, _data.receiver
        );
    }

    /// @notice Internal function to perform a zap-out operation (sUSD to
    /// Collateral)
    /// @param _data ZapData struct containing all necessary information
    function _zapOut(ZapData calldata _data) private {
        uint256 amount = _data.amount;

        IERC20 sUSD = IERC20(_data.spotMarket.getSynth(USD_SPOT_MARKET_ID));
        sUSD.transferFrom(msg.sender, address(this), amount);

        sUSD.approve(address(_data.spotMarket), amount);

        try _data.spotMarket.buy({
            marketId: _data.marketId,
            usdAmount: amount,
            minAmountReceived: _data.tolerance.tolerableSwapAmount,
            referrer: _data.referrer
        }) returns (uint256 synthAmount, ISpotMarketProxy.Data memory) {
            amount = synthAmount;
        } catch Error(string memory reason) {
            revert SwapFailed(reason);
        }

        IERC20 synth = IERC20(_data.spotMarket.getSynth(_data.marketId));
        synth.approve(address(_data.spotMarket), amount);

        try _data.spotMarket.unwrap({
            marketId: _data.marketId,
            unwrapAmount: amount,
            minAmountReceived: _data.tolerance.tolerableWrapAmount
        }) returns (
            uint256 returnCollateralAmount, ISpotMarketProxy.Data memory
        ) {
            amount = returnCollateralAmount;
        } catch Error(string memory reason) {
            revert UnwrapFailed(reason);
        }

        _data.collateral.transfer(_data.receiver, amount);

        emit ZapOut(
            msg.sender, _data.marketId, _data.amount, amount, _data.receiver
        );
    }

    /// @notice Function to wrap collateral into a synth
    /// @param _data ZapData struct containing all necessary information
    function wrap(ZapData calldata _data) external {
        uint256 amount = _data.amount;

        _data.collateral.transferFrom(msg.sender, address(this), amount);
        _data.collateral.approve(address(_data.spotMarket), amount);

        try _data.spotMarket.wrap({
            marketId: _data.marketId,
            wrapAmount: amount,
            minAmountReceived: _data.tolerance.tolerableWrapAmount
        }) returns (uint256 amountToMint, ISpotMarketProxy.Data memory) {
            amount = amountToMint;
        } catch Error(string memory reason) {
            revert WrapFailed(reason);
        }

        IERC20 synth = IERC20(_data.spotMarket.getSynth(_data.marketId));
        synth.approve(address(_data.spotMarket), amount);

        synth.transfer(_data.receiver, amount);

        emit Wrapped(
            msg.sender, _data.marketId, _data.amount, amount, _data.receiver
        );
    }

    /// @notice Function to unwrap a synth back into collateral
    /// @param _data ZapData struct containing all necessary information
    function unwrap(ZapData calldata _data) external {
        uint256 amount = _data.amount;

        IERC20 synth = IERC20(_data.spotMarket.getSynth(_data.marketId));
        synth.approve(address(_data.spotMarket), amount);

        try _data.spotMarket.unwrap({
            marketId: _data.marketId,
            unwrapAmount: amount,
            minAmountReceived: _data.tolerance.tolerableWrapAmount
        }) returns (
            uint256 returnCollateralAmount, ISpotMarketProxy.Data memory
        ) {
            amount = returnCollateralAmount;
        } catch Error(string memory reason) {
            revert UnwrapFailed(reason);
        }

        _data.collateral.transfer(_data.receiver, amount);

        emit Unwrapped(
            msg.sender, _data.marketId, _data.amount, amount, _data.receiver
        );
    }

}
