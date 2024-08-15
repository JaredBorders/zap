// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

contract ArbitrumSepoliaParameters {
    // https://arbiscan
    address public constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;

    // https://arbiscan
    address public constant SPOT_MARKET_PROXY =
        0x18141523403e2595D31b22604AcB8Fc06a4CaA61;

    // https://arbiscan
    address public constant USD_PROXY =
        0x09d51516F38980035153a554c26Df3C6f51a23C3;

    // https://arbiscan
    uint128 public constant SUSDC_SPOT_MARKET_ID = 1;
}
