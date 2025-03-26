// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract Base {

    /// @custom:pdao
    address BASE_PDAO = 0xbb63CA5554dc4CcaCa4EDd6ECC2837d5EFe83C82;

    /// @custom:synthetix
    address BASE_USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address BASE_SUSD = 0x09d51516F38980035153a554c26Df3C6f51a23C3;
    address BASE_SSTATA = 0x729Ef31D86d31440ecBF49f27F7cD7c16c6616d2;
    address BASE_SPOT_MARKET = 0x18141523403e2595D31b22604AcB8Fc06a4CaA61;
    address BASE_PERPS_MARKET = 0x0A2AF931eFFd34b81ebcc57E3d3c9B1E1dE1C9Ce;
    address BASE_REFERRER = address(0);
    uint128 BASE_SUSDC_SPOT_MARKET_ID = 1;
    uint128 BASE_SSTATA_SPOT_MARKET_ID = 3;

    /// @custom:aave
    address BASE_AAVE_POOL = 0xA238Dd80C259a72e81d7e4664a9801593F98d1c5;
    address BASE_STATA = 0x4EA71A20e655794051D1eE8b6e4A3269B13ccaCc;

    /// @custom:odos
    address BASE_ROUTER = 0x19cEeAd7105607Cd444F5ad10dd51356436095a1;

}

//TODO: add addresses
contract BaseSepolia {

    /// @custom:pdao
    address BASE_SEPOLIA_PDAO = address(0);

    /// @custom:synthetix
    address BASE_SEPOLIA_USDC = 0x5dEaC602762362FE5f135FA5904351916053cF70;
    address BASE_SEPOLIA_SUSD = address(0);
    address BASE_SEPOLIA_SPOT_MARKET = address(0);
    address BASE_SEPOLIA_PERPS_MARKET = address(0);
    address BASE_SEPOLIA_REFERRER = address(0);
    uint128 BASE_SEPOLIA_SUSDC_SPOT_MARKET_ID = 0;

    /// @custom:aave
    address BASE_SEPOLIA_AAVE_POOL = address(0);

    /// @custom:odos
    address BASE_SEPOLIA_ROUTER = address(0);

}
