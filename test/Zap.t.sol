// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {Bootstrap} from "test/utils/Bootstrap.sol";

contract ZapTest is Bootstrap {
    function setUp() public {
        vm.rollFork(8163000);
        initializeBase();
    }
}

contract ZapIn is ZapTest {
    function test_zap_in() public {
        assert(address(zap) != address(0));
    }
}

contract ZapOut is ZapTest {
    function test_zap_out() public {
        assert(address(zap) != address(0));
    }
}
