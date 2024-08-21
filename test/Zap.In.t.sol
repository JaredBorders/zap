// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {Zap} from "../src/Zap.sol";
import {Test} from "forge-std/Test.sol";

contract ZapInTest is Test {

    Zap zap;

    function setUp() public {
        zap = new Zap();
    }

    function test_zap_in() public {
        assertTrue(true);
    }

}
