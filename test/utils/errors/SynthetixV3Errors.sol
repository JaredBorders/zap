// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

/// @title Cosolidated Errors from Synthetix v3 contracts
/// @author JaredBorders (jaredborders@pm.me)
contract SynthetixV3Errors {

    enum SettlementStrategyType {
        PYTH
    }

    error WrapperExceedsMaxAmount(
        uint256 maxWrappableAmount, uint256 currentSupply, uint256 amountToWrap
    );
    error OffchainLookup(
        address sender,
        string[] urls,
        bytes callData,
        bytes4 callbackFunction,
        bytes extraData
    );
    error ArbGasPriceOracleInvalidExecutionKind();
    error InvalidId(uint128 id);
    error FeatureUnavailable(bytes32 which);
    error InvalidVerificationResponse();
    error InvalidSettlementStrategy(uint256 settlementStrategyId);
    error MinimumSettlementAmountNotMet(uint256 minimum, uint256 actual);
    error SettlementStrategyNotFound(SettlementStrategyType strategyType);
    error InvalidFeeCollectorInterface(address invalidFeeCollector);
    error InvalidReferrerShareRatio(uint256 shareRatioD18);
    error NotEligibleForLiquidation(uint128 accountId);
    error InvalidAmountDelta(int256 amountDelta);
    error InvalidArgument();
    error InvalidUpdateDataSource();
    error InvalidUpdateData();
    error InsufficientFee();
    error NoFreshUpdate();
    error PriceFeedNotFoundWithinRange();
    error PriceFeedNotFound();
    error StalePrice();
    error InvalidWormholeVaa();
    error InvalidGovernanceMessage();
    error InvalidGovernanceTarget();
    error InvalidGovernanceDataSource();
    error OldGovernanceMessage();
    error SettlementWindowNotOpen(uint256 timestamp, uint256 settlementTime);
    error SettlementWindowExpired(
        uint256 timestamp, uint256 settlementTime, uint256 settlementExpiration
    );
    error SettlementWindowNotExpired(
        uint256 timestamp, uint256 settlementTime, uint256 settlementExpiration
    );
    error OrderNotValid();
    error AcceptablePriceExceeded(uint256 fillPrice, uint256 acceptablePrice);
    error PendingOrderExists();
    error ZeroSizeOrder();
    error InsufficientMargin(int256 availableMargin, uint256 minMargin);
    error MaxCollateralExceeded(
        uint128 synthMarketId,
        uint256 maxAmount,
        uint256 collateralAmount,
        uint256 depositAmount
    );
    error SynthNotEnabledForCollateral(uint128 synthMarketId);
    error InsufficientCollateral(
        uint128 synthMarketId, uint256 collateralAmount, uint256 withdrawAmount
    );
    error InsufficientCollateralAvailableForWithdraw(
        uint256 available, uint256 required
    );
    error InsufficientMarginError(uint256 leftover);
    error AccountLiquidatable(uint128 accountId);
    error MaxPositionsPerAccountReached(uint128 maxPositionsPerAccount);
    error MaxCollateralsPerAccountReached(uint128 maxCollateralsPerAccount);
    error InvalidMarket(uint128 marketId);
    error PriceFeedNotSet(uint128 marketId);
    error MarketAlreadyExists(uint128 marketId);
    error MaxOpenInterestReached(
        uint128 marketId, uint256 maxMarketSize, int256 newSideSize
    );
    error PerpsMarketNotInitialized();
    error PerpsMarketAlreadyInitialized();
    error PriceDeviationToleranceExceeded(uint256 deviation, uint256 tolerance);
    error ExceedsMaxUsdAmount(uint256 maxUsdAmount, uint256 usdAmountCharged);
    error ExceedsMaxSynthAmount(
        uint256 maxSynthAmount, uint256 synthAmountCharged
    );
    error InsufficientAmountReceived(uint256 expected, uint256 current);
    error InvalidPrices();
    error InvalidWrapperFees();
    error NotNominated(address addr);
    error InvalidMarketOwner();
    error InsufficientSharesAmount(uint256 expected, uint256 actual);
    error OutsideSettlementWindow(
        uint256 timestamp, uint256 startTime, uint256 expirationTime
    );
    error IneligibleForCancellation(uint256 timestamp, uint256 expirationTime);
    error OrderAlreadySettled(uint256 asyncOrderId, uint256 settledAt);
    error InvalidClaim(uint256 asyncOrderId);
    error OnlyAccountTokenProxy(address origin);
    error PermissionNotGranted(
        uint128 accountId, bytes32 permission, address user
    );
    error InsufficientSynthCollateral(
        uint128 collateralId, uint256 collateralAmount, uint256 withdrawAmount
    );
    error InsufficientAccountMargin(uint256 leftover);
    error AccountMarginLiquidatable(uint128 accountId);
    error NonexistentDebt(uint128 accountId);
    error InvalidAccountId(uint128 accountId);
    error Unauthorized(address addr);
    error CannotSelfApprove(address addr);
    error InvalidTransferRecipient(address addr);
    error InvalidOwner(address addr);
    error TokenDoesNotExist(uint256 id);
    error TokenAlreadyMinted(uint256 id);
    error PermissionDenied(
        uint128 accountId, bytes32 permission, address target
    );
    error InsufficientBalance(uint256 required, uint256 existing);
    error InsufficientAllowance(uint256 required, uint256 existing);
    error InvalidParameter(string parameter, string reason);

}
