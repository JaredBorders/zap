// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Bootstrap} from "./Bootstrap.sol";
import "forge-std/console2.sol";

contract BootstrapWithCurrentBlock is Bootstrap {

    function setUp() public override {
        string memory BASE_RPC = vm.envString(BASE_RPC_REF);
        string memory ARBITRUM_RPC = vm.envString(ARBITRUM_RPC_REF);
        string memory ARBITRUM_SEPOLIA_RPC =
            vm.envString(ARBITRUM_SEPOLIA_RPC_REF);

        BASE = vm.createFork(BASE_RPC);
        ARBITRUM = vm.createFork(ARBITRUM_RPC);
        ARBITRUM_SEPOLIA = vm.createFork(ARBITRUM_SEPOLIA_RPC);

        headers.push("Content-Type: application/json");
    }

}
