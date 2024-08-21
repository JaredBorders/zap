// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Zap} from "../src/Zap.sol";

/// @title Zap deployment script
/// @author JaredBorders (jaredborders@pm.me)
contract Setup is Script {

    function deploySystem() public returns (address zap) {
        zap = address(new Zap());
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

/// @dev steps to deploy and verify on Base Sepolia:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployBaseSepolia --rpc-url
/// $BASE_SEPOLIA_RPC_URL --etherscan-api-key $BASESCAN_API_KEY --broadcast
/// --verify -vvvv`
contract DeployBaseSepolia is Setup {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem();

        vm.stopBroadcast();
    }

}

/// @dev steps to deploy and verify on Optimism:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployOptimism --rpc-url
/// $OPTIMISM_RPC_URL --etherscan-api-key $OPTIMISM_ETHERSCAN_API_KEY
/// --broadcast --verify -vvvv`
contract DeployOptimism is Setup {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem();

        vm.stopBroadcast();
    }

}

/// @dev steps to deploy and verify on Optimism Sepolia:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployOptimismSepolia --rpc-url
/// $OPTIMISM_SEPOLIA_RPC_URL --etherscan-api-key $OPTIMISM_ETHERSCAN_API_KEY
/// --broadcast --verify -vvvv`
contract DeployOptimismSepolia is Setup {

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

/// @dev steps to deploy and verify on Arbitrum Sepolia:
/// (1) load the variables in the .env file via `source .env`
/// (2) run `forge script script/Deploy.s.sol:DeployArbitrumSepolia --rpc-url
/// $ARBITRUM_SEPOLIA_RPC_URL --etherscan-api-key $ARBITRUM_SEPOLIA_RPC_URL
/// --broadcast --verify -vvvv`
contract DeployArbitrumSepolia is Setup {

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Setup.deploySystem();

        vm.stopBroadcast();
    }

}
