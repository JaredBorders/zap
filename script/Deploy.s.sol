// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Zap} from "../src/Zap.sol";

/// @title Zap deployment script
/// @author JaredBorders (jaredborders@pm.me)
contract Setup is Script {

    /// @custom:todo
    function deploySystem() public returns (address zap) {
        // zap = address(new Zap());
    }

}

/// @dev steps to deploy and verify on Base:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployBase --rpc-url $BASE_RPC_URL
/// --etherscan-api-key $BASESCAN_API_KEY --broadcast --verify -vvvv`
contract DeployBase is Setup {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem();

        vm.stopBroadcast();
    }

}

/// @dev steps to deploy and verify on Arbitrum:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployArbitrum --rpc-url
/// $ARBITRUM_RPC_URL --etherscan-api-key $ARBITRUM_RPC_URL
/// --broadcast --verify -vvvv`
contract DeployArbitrum is Setup {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem();

        vm.stopBroadcast();
    }

}
