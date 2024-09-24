// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract Constants {

    /// @custom:zap
    string constant BASE_RPC_REF = "BASE_RPC";
    string constant ARBITRUM_RPC_REF = "ARBITRUM_RPC";
    uint256 constant BASE_FORK_BLOCK = 20_165_000;
    uint256 constant ARBITRUM_FORK_BLOCK_DEBT = 256_215_787;
    uint256 constant ARBITRUM_FORK_BLOCK = 256_615_000;
    address constant ACTOR = 0x7777777777777777777777777777777777777777;
    address constant ARBITRUM_BOB = 0x3bd5e344Ac629C9f232F921bAfDeEEc312deAC9b;
    uint128 constant ARBITRUM_BOB_ID =
        170_141_183_460_469_231_731_687_303_715_884_105_912;
    uint256 constant DEFAULT_TOLERANCE = 0;

    /// @custom:tokens
    address constant ARBITRUM_WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address constant BASE_WETH = 0x4200000000000000000000000000000000000006;

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
