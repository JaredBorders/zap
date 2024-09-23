// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract Types {

    /// @notice enumerated type for the direction of a zap operation
    /// @custom:IN collateral -> synthetix stablecoin
    /// @custom:OUT synthetix collateral -> collateral
    enum Direction {
        IN,
        OUT
    }

    /// @notice tolerance levels for wrap and swap operations
    /// @param tolerableWrapAmount minimum acceptable amount for wrap operation
    /// @param tolerableSwapAmount minimum acceptable amount for swap operation
    struct Tolerance {
        uint256 tolerableWrapAmount;
        uint256 tolerableSwapAmount;
    }

    /// @notice structure of data required for any zap operation
    /// @param spotMarket address of the spot market proxy
    /// @param collateral address of the collateral token
    /// @param marketId identifier of the spot market
    /// @param amount of tokens to zap
    /// @param tolerance levels for wrap and swap operations
    /// @param direction of the zap operation
    /// @param receiver address to receive the output tokens
    /// @param referrer address of the referrer
    struct ZapData {
        address spotMarket;
        address collateral;
        uint128 marketId;
        uint256 amount;
        Tolerance tolerance;
        Direction direction;
        address receiver;
        address referrer;
    }

    /// @notice structure of data required for a flash loan operation
    /// @param asset address of the asset to be borrowed
    /// @param amount of the asset to be borrowed
    /// @param premium fee to be paid for the flash loan
    /// @param initiator address of the flash loan operation
    /// @param params parameters needed for initiating the loan
    struct FlashData {
        address asset;
        uint256 amount;
        uint256 premium;
        address initiator;
        bytes params;
    }

}
