// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

/// @title Zap contract events
/// @author JaredBorders (jaredborders@pm.me)
contract ZapEvents {

    /// @notice Emitted when a zap-in operation is performed (Collateral to
    /// sUSD)
    /// @param initiator Address that initiated the zap-in
    /// @param marketId ID of the market involved
    /// @param collateralAmount Amount of collateral input
    /// @param sUSDAmount Amount of sUSD output
    /// @param receiver Address that received the sUSD
    event ZapIn(
        address indexed initiator,
        uint128 indexed marketId,
        uint256 collateralAmount,
        uint256 sUSDAmount,
        address indexed receiver
    );

    /// @notice Emitted when a zap-out operation is performed (sUSD to
    /// Collateral)
    /// @param initiator Address that initiated the zap-out
    /// @param marketId ID of the market involved
    /// @param sUSDAmount Amount of sUSD input
    /// @param collateralAmount Amount of collateral output
    /// @param receiver Address that received the collateral
    event ZapOut(
        address indexed initiator,
        uint128 indexed marketId,
        uint256 sUSDAmount,
        uint256 collateralAmount,
        address indexed receiver
    );

    /// @notice Emitted when a wrap operation is performed
    /// @param initiator Address that initiated the wrap
    /// @param marketId ID of the market involved
    /// @param collateralAmount Amount of collateral wrapped
    /// @param synthAmount Amount of synth received
    /// @param receiver Address that received the synth tokens
    event Wrapped(
        address indexed initiator,
        uint128 indexed marketId,
        uint256 collateralAmount,
        uint256 synthAmount,
        address indexed receiver
    );

    /// @notice Emitted when an unwrap operation is performed
    /// @param initiator Address that initiated the unwrap
    /// @param marketId ID of the market involved
    /// @param synthAmount Amount of synth unwrapped
    /// @param collateralAmount Amount of collateral received
    /// @param receiver Address that received the collateral tokens
    event Unwrapped(
        address indexed initiator,
        uint128 indexed marketId,
        uint256 synthAmount,
        uint256 collateralAmount,
        address indexed receiver
    );

}
