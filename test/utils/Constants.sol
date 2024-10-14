// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract Constants {

    /// @custom:forks
    string constant BASE_RPC_REF = "BASE_RPC";
    string constant ARBITRUM_RPC_REF = "ARBITRUM_RPC";
    string constant ARBITRUM_SEPOLIA_RPC_REF = "ARBITRUM_SEPOLIA_RPC";
    uint256 constant BASE_FORK_BLOCK = 20_165_000;
    uint256 constant ARBITRUM_FORK_BLOCK = 256_615_000;
    uint256 constant ARBITRUM_SEPOLIA_FORK_BLOCK = 85_443_000;

    /// @custom:values
    address constant ACTOR = 0x7777777777777777777777777777777777777777;
    uint256 constant DEFAULT_TOLERANCE = 0;

    /// @custom:tokens
    address constant ARBITRUM_WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address constant ARBITRUM_TBTC = 0x6c84a8f1c29108F47a79964b5Fe888D4f4D0dE40;
    address constant ARBITRUM_SEPOLIA_WETH = address(0);
    address constant BASE_WETH = 0x4200000000000000000000000000000000000006;
    address constant BASE_TBTC = 0x236aa50979D5f3De3Bd1Eeb40E81137F22ab794b;

    uint24 constant FEE_30 = 3000;
    uint24 constant FEE_100 = 10_000;

    /// @custom:synthetix
    bytes32 constant _ADMIN_PERMISSION = "ADMIN";
    bytes32 constant _WITHDRAW_PERMISSION = "WITHDRAW";
    bytes32 constant _DELEGATE_PERMISSION = "DELEGATE";
    bytes32 constant _MINT_PERMISSION = "MINT";
    bytes32 constant _REWARDS_PERMISSION = "REWARDS";
    bytes32 constant _PERPS_MODIFY_COLLATERAL_PERMISSION =
        "PERPS_MODIFY_COLLATERAL";
    bytes32 constant _PERPS_COMMIT_ASYNC_ORDER_PERMISSION =
        "PERPS_COMMIT_ASYNC_ORDER";
    bytes32 constant _BURN_PERMISSION = "BURN";
    bytes32 constant _BFP_PERPS_PAY_DEBT_PERMISSION = "BFP_PERPS_PAY_DEBT";
    bytes32 constant _BFP_PERPS_SPLIT_ACCOUNT_PERMISSION =
        "BFP_PERPS_SPLIT_ACCOUNT";

}
