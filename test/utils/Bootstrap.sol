// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {console2} from "lib/forge-std/src/console2.sol";
import {
    Counter,
    OptimismGoerliParameters,
    OptimismParameters,
    Setup
} from "script/Deploy.s.sol";
import {Test} from "lib/forge-std/src/Test.sol";

contract Bootstrap is Test {
    using console2 for *;

    Counter internal counter;

    function initializeLocal() internal {
        BootstrapLocal bootstrap = new BootstrapLocal();
        (address counterAddress) = bootstrap.init();

        counter = Counter(counterAddress);
    }

    function initializeOptimismGoerli() internal {
        BootstrapOptimismGoerli bootstrap = new BootstrapOptimismGoerli();
        (address counterAddress) = bootstrap.init();

        counter = Counter(counterAddress);
    }

    function initializeOptimism() internal {
        BootstrapOptimismGoerli bootstrap = new BootstrapOptimismGoerli();
        (address counterAddress) = bootstrap.init();

        counter = Counter(counterAddress);
    }

    /// @dev add other networks here as needed (ex: Base, BaseGoerli)
}

contract BootstrapLocal is Setup {
    function init() public returns (address) {
        address counterAddress = Setup.deploySystem();

        return counterAddress;
    }
}

contract BootstrapOptimism is Setup, OptimismParameters {
    function init() public returns (address) {
        address counterAddress = Setup.deploySystem();

        return counterAddress;
    }
}

contract BootstrapOptimismGoerli is Setup, OptimismGoerliParameters {
    function init() public returns (address) {
        address counterAddress = Setup.deploySystem();

        return counterAddress;
    }
}

// add other networks here as needed (ex: Base, BaseGoerli)
