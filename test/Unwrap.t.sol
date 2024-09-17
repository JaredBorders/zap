// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {Zap} from "../src/Zap.sol";
import {ZapErrors} from "../src/ZapErrors.sol";
import {ZapEvents} from "../src/ZapEvents.sol";

import {MockERC20} from "./utils/mocks/MockERC20.sol";
import {MockSpotMarketProxy} from "./utils/mocks/MockSpotMarketProxy.sol";
import {Test} from "forge-std/Test.sol";

contract UnwrapTest is Test, ZapEvents {

    Zap public zap;
    MockERC20 public collateral;
    MockERC20 public synth;
    MockSpotMarketProxy public spotMarket;

    address public constant RECEIVER = address(0x123);
    address public constant REFERRER = address(0x456);
    uint128 public constant MARKET_ID = 1;
    uint256 public constant INITIAL_BALANCE = 1000e18;

    function setUp() public {
        zap = new Zap();
        collateral = new MockERC20("Collateral", "COL", 18);
        synth = new MockERC20("Synth", "SYN", 18);
        spotMarket = new MockSpotMarketProxy();

        // Set the synth address in the MockSpotMarketProxy
        spotMarket.setSynthAddress(MARKET_ID, address(synth));

        // Setup initial balances and approvals
        synth.mint(address(this), INITIAL_BALANCE);
        synth.approve(address(zap), type(uint256).max);

        // Mint collateral to the Zap contract instead of the SpotMarketProxy
        collateral.mint(address(zap), INITIAL_BALANCE);
    }

    function test_unwrap_success() public {
        uint256 amount = 100e18;
        uint256 expectedOutput = amount; // Assuming 1:1 ratio for simplicity

        Zap.ZapData memory zapData = Zap.ZapData({
            spotMarket: spotMarket,
            collateral: collateral,
            marketId: MARKET_ID,
            amount: amount,
            tolerance: Zap.Tolerance({
                tolerableWrapAmount: amount * 95 / 100,
                tolerableSwapAmount: 0 // Not used for unwrap
            }),
            direction: Zap.Direction.Out, // Not used for unwrap
            receiver: RECEIVER,
            referrer: REFERRER // Not used for unwrap
        });

        vm.expectEmit(true, true, true, true);
        emit Unwrapped(
            address(this), MARKET_ID, amount, expectedOutput, RECEIVER
        );

        zap.unwrap(zapData);

        // Assert the final state
        assertEq(collateral.balanceOf(RECEIVER), expectedOutput);
    }

    function test_unwrap_failed() public {
        uint256 amount = 100e18;

        // Setup to make unwrap fail
        spotMarket.setUnwrapShouldRevert(true);

        Zap.ZapData memory zapData = Zap.ZapData({
            spotMarket: spotMarket,
            collateral: collateral,
            marketId: MARKET_ID,
            amount: amount,
            tolerance: Zap.Tolerance({
                tolerableWrapAmount: amount * 95 / 100,
                tolerableSwapAmount: 0 // Not used for unwrap
            }),
            direction: Zap.Direction.Out, // Not used for unwrap
            receiver: RECEIVER,
            referrer: REFERRER // Not used for unwrap
        });

        vm.expectRevert(
            abi.encodeWithSelector(
                ZapErrors.UnwrapFailed.selector, "Unwrap failed"
            )
        );
        zap.unwrap(zapData);
    }

}
