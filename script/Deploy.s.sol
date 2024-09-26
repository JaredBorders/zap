// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Zap} from "../src/Zap.sol";
import {Arbitrum, ArbitrumSepolia, Base} from "./utils/Parameters.sol";

/// @title Zap deployment script
/// @author JaredBorders (jaredborders@pm.me)
contract Setup is Script {

    /// @custom:todo
    function deploySystem(
        address usdc,
        address usdx,
        address spotMarket,
        address perpsMarket,
        address core,
        address referrer,
        uint128 susdcSpotId,
        address aave,
        address uniswap
    )
        public
        returns (Zap zap)
    {
        zap = new Zap({
            _usdc: usdc,
            _usdx: usdx,
            _spotMarket: spotMarket,
            _perpsMarket: perpsMarket,
            _core: core,
            _referrer: referrer,
            _susdcSpotId: susdcSpotId,
            _aave: aave,
            _uniswap: uniswap
        });
    }

}

/// @dev steps to deploy and verify on Base:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployBase --rpc-url $BASE_RPC_URL
/// --etherscan-api-key $BASESCAN_API_KEY --broadcast --verify -vvvv`
contract DeployBase is Setup, Base {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem({
            usdc: BASE_USDC,
            usdx: BASE_USDX,
            spotMarket: BASE_SPOT_MARKET,
            perpsMarket: BASE_PERPS_MARKET,
            core: BASE_CORE,
            referrer: BASE_REFERRER,
            susdcSpotId: BASE_SUSDC_SPOT_MARKET_ID,
            aave: BASE_AAVE_POOL,
            uniswap: BASE_UNISWAP
        });

        vm.stopBroadcast();
    }

}

/// @dev steps to deploy and verify on Arbitrum:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployArbitrum --rpc-url
/// $ARBITRUM_RPC_URL
/// --etherscan-api-key $ARBITRUM_RPC_URL --broadcast --verify -vvvv`
contract DeployArbitrum is Setup, Arbitrum {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem({
            usdc: ARBITRUM_USDC,
            usdx: ARBITRUM_USDX,
            spotMarket: ARBITRUM_SPOT_MARKET,
            perpsMarket: ARBITRUM_PERPS_MARKET,
            core: ARBITRUM_CORE,
            referrer: ARBITRUM_REFERRER,
            susdcSpotId: ARBITRUM_SUSDC_SPOT_MARKET_ID,
            aave: ARBITRUM_AAVE_POOL,
            uniswap: ARBITRUM_UNISWAP
        });

        vm.stopBroadcast();
    }

}

/// @dev steps to deploy and verify on Arbitrum:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployArbitrumSepolia --rpc-url
/// $ARBITRUM_SEPOLIA_RPC_URL
/// --etherscan-api-key $ARBITRUM_RPC_URL --broadcast --verify -vvvv`
contract DeployArbitrumSepolia is Setup, ArbitrumSepolia {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem({
            usdc: ARBITRUM_SEPOLIA_USDC,
            usdx: ARBITRUM_SEPOLIA_USDX,
            spotMarket: ARBITRUM_SEPOLIA_SPOT_MARKET,
            perpsMarket: ARBITRUM_SEPOLIA_PERPS_MARKET,
            core: ARBITRUM_SEPOLIA_CORE,
            referrer: ARBITRUM_SEPOLIA_REFERRER,
            susdcSpotId: ARBITRUM_SEPOLIAS_USDC_SPOT_MARKET_ID,
            aave: ARBITRUM_SEPOLIA_AAVE_POOL,
            uniswap: ARBITRUM_SEPOLIA_UNISWAP
        });

        vm.stopBroadcast();
    }

}
