// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Flush, Zap} from "../src/Zap.sol";
import {Base, BaseSepolia} from "./utils/Parameters.sol";

/// @title zap deployment script
/// @author @jaredborders
/// @author @flocqst
contract Deploy is Script {

    modifier broadcast() {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        _;
        vm.stopBroadcast();
    }

    function deploySystem(
        address usdc,
        address susd,
        address sstata,
        address spotMarket,
        address perpsMarket,
        address referrer,
        uint128 susdcSpotId,
        uint128 sstataSpotId,
        address aave,
        address stata,
        address router
    )
        public
        returns (Zap zap)
    {
        zap = new Zap({
            _usdc: usdc,
            _susd: susd,
            _sstata: sstata,
            _spotMarket: spotMarket,
            _perpsMarket: perpsMarket,
            _referrer: referrer,
            _susdcSpotId: susdcSpotId,
            _sstataSpotId: sstataSpotId,
            _aave: aave,
            _stata: stata,
            _router: router
        });
    }

}

/// @custom:deploy `make deploy_base`
contract DeployBase is Deploy, Base {

    function run() public broadcast {
        Zap zap = deploySystem({
            usdc: BASE_USDC,
            susd: BASE_SUSD,
            sstata: BASE_SSTATA,
            spotMarket: BASE_SPOT_MARKET,
            perpsMarket: BASE_PERPS_MARKET,
            referrer: BASE_REFERRER,
            susdcSpotId: BASE_SUSDC_SPOT_MARKET_ID,
            sstataSpotId: BASE_SSTATA_SPOT_MARKET_ID,
            aave: BASE_AAVE_POOL,
            stata: BASE_STATA,
            router: BASE_ROUTER
        });
        // PDAO will have to accept Nomination
        Flush(address(zap)).nominatePlumber(BASE_PDAO);
    }

}

/// @custom:deploy `make deploy_basesepolia`
contract DeployBaseSepolia is Deploy, BaseSepolia {

    function run() public broadcast {
        Zap zap = deploySystem({
            usdc: BASE_SEPOLIA_USDC,
            susd: BASE_SEPOLIA_SUSD,
            sstata: address(0), //todo we are not deploying this stata release
                // to base
            spotMarket: BASE_SEPOLIA_SPOT_MARKET,
            perpsMarket: BASE_SEPOLIA_PERPS_MARKET,
            referrer: BASE_SEPOLIA_REFERRER,
            susdcSpotId: BASE_SEPOLIA_SUSDC_SPOT_MARKET_ID,
            sstataSpotId: 0, //todo we are not deploying this stata release to
                // base
            aave: BASE_SEPOLIA_AAVE_POOL,
            stata: address(0), //todo we are not deploying this stata release to
                // base
            router: BASE_SEPOLIA_ROUTER
        });
        Flush(address(zap)).nominatePlumber(BASE_SEPOLIA_PDAO);
    }

}
