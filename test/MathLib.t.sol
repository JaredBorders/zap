// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {MathLib} from "../src/libraries/MathLib.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract MathLibTest is Test {
    using MathLib for int256;

    function test_abs256() public {
        int256 x = -1 ether;
        uint256 z = x.abs256();
        assertEq(z, 1 ether);

        x = type(int256).min;
        z = x.abs256();
        assertEq(z, 2 ** 255);

        x = type(int256).max;
        z = x.abs256();
        assertEq(z, (2 ** 255) - 1);

        int256 y = (2 ** 255) - 1;
        assertEq(x, y);
    }

    function test_fuzz_abs256(int256 x) public {
        uint256 z;

        if (x == type(int256).min) {
            z = x.abs256();
            assertEq(z, 2 ** 255);
        } else if (x == type(int256).max) {
            z = x.abs256();
            assertEq(z, (2 ** 255) - 1);
        } else {
            z = x.abs256();
            x = x < 0 ? -x : x;
            uint256 y = uint256(x);
            assertEq(z, y);
        }
    }
}
