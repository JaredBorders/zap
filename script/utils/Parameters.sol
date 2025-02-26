// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract Base {

    /// @custom:pdao
    address BASE_PDAO = 0xbb63CA5554dc4CcaCa4EDd6ECC2837d5EFe83C82;

    /// @custom:synthetix
    address BASE_USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address BASE_USDX = 0x09d51516F38980035153a554c26Df3C6f51a23C3;
    address BASE_SPOT_MARKET = 0x18141523403e2595D31b22604AcB8Fc06a4CaA61;
    address BASE_PERPS_MARKET = 0x0A2AF931eFFd34b81ebcc57E3d3c9B1E1dE1C9Ce;
    address BASE_REFERRER = address(0);
    uint128 BASE_SUSDC_SPOT_MARKET_ID = 1;

    /// @custom:aave
    address BASE_AAVE_POOL = 0xA238Dd80C259a72e81d7e4664a9801593F98d1c5;

    /// @custom:odos
    address BASE_ROUTER = 0x19cEeAd7105607Cd444F5ad10dd51356436095a1;

}

contract Arbitrum {

    /// @custom:pdao
    address ARBITRUM_PDAO = 0xD3DFa13CDc7c133b1700c243f03A8C6Df513A93b;

    /// @custom:synthetix
    address ARBITRUM_USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address ARBITRUM_USDX = 0xb2F30A7C980f052f02563fb518dcc39e6bf38175;
    address ARBITRUM_SPOT_MARKET = 0xa65538A6B9A8442854dEcB6E3F85782C60757D60;
    address ARBITRUM_PERPS_MARKET = 0xd762960c31210Cf1bDf75b06A5192d395EEDC659;
    address ARBITRUM_REFERRER = address(0);
    uint128 ARBITRUM_SUSDC_SPOT_MARKET_ID = 2;

    /// @custom:aave
    address ARBITRUM_AAVE_POOL = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;

    /// @custom:odos
    address ARBITRUM_ROUTER = 0xa669e7A0d4b3e4Fa48af2dE86BD4CD7126Be4e13;

}

contract ArbitrumSepolia {

    /// @custom:pdao
    address ARBITRUM_SEPOLIA_PDAO = address(0);

    /// @custom:synthetix
    address ARBITRUM_SEPOLIA_USDC = 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d;
    address ARBITRUM_SEPOLIA_USDX = 0xe487Ad4291019b33e2230F8E2FB1fb6490325260;
    address ARBITRUM_SEPOLIA_SPOT_MARKET =
        0x93d645c42A0CA3e08E9552367B8c454765fff041;
    address ARBITRUM_SEPOLIA_PERPS_MARKET =
        0xA73A7B754Ec870b3738D0654cA75b7d0eEbdb460;
    address ARBITRUM_SEPOLIA_REFERRER = address(0);
    uint128 ARBITRUM_SEPOLIA_SUSDC_SPOT_MARKET_ID = 2;

    /// @custom:aave
    address ARBITRUM_SEPOLIA_AAVE_POOL =
        0xBfC91D59fdAA134A4ED45f7B584cAf96D7792Eff;

    /// @custom:odos
    address ARBITRUM_SEPOLIA_ROUTER = address(0);

}
