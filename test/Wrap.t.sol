// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {Zap} from "../src/Zap.sol";
import {ZapErrors} from "../src/ZapErrors.sol";
import {ZapEvents} from "../src/ZapEvents.sol";

import {MockERC20} from "./utils/mocks/MockERC20.sol";
import {MockSpotMarketProxy} from "./utils/mocks/MockSpotMarketProxy.sol";
import {Test} from "forge-std/Test.sol";

contract WrapTest is Test, ZapEvents {

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
        collateral.mint(address(this), INITIAL_BALANCE);
        collateral.approve(address(zap), type(uint256).max);

        // Mint synth tokens to the MockSpotMarketProxy for it to transfer
        // during 'wrap'
        synth.mint(address(zap), INITIAL_BALANCE);
    }

    function test_wrap_success() public {
        uint256 amount = 100e18;
        uint256 expectedOutput = amount; // Assuming 1:1 ratio for simplicity

        Zap.ZapData memory zapData = Zap.ZapData({
            spotMarket: spotMarket,
            collateral: collateral,
            marketId: MARKET_ID,
            amount: amount,
            tolerance: Zap.Tolerance({
                tolerableWrapAmount: amount * 95 / 100,
                tolerableSwapAmount: 0 // Not used for wrap
            }),
            direction: Zap.Direction.In, // Not used for wrap
            receiver: RECEIVER,
            referrer: REFERRER // Not used for wrap
        });

        vm.expectEmit(true, true, true, true);
        emit Wrapped(address(this), MARKET_ID, amount, expectedOutput, RECEIVER);

        zap.wrap(zapData);

        // Assert the final state
        assertEq(synth.balanceOf(RECEIVER), expectedOutput);
    }

    function test_wrap_failed() public {
        uint256 amount = 100e18;

        // Setup to make wrap fail
        spotMarket.setWrapShouldRevert(true);

        Zap.ZapData memory zapData = Zap.ZapData({
            spotMarket: spotMarket,
            collateral: collateral,
            marketId: MARKET_ID,
            amount: amount,
            tolerance: Zap.Tolerance({
                tolerableWrapAmount: amount * 95 / 100,
                tolerableSwapAmount: 0 // Not used for wrap
            }),
            direction: Zap.Direction.In, // Not used for wrap
            receiver: RECEIVER,
            referrer: REFERRER // Not used for wrap
        });

        vm.expectRevert(
            abi.encodeWithSelector(ZapErrors.WrapFailed.selector, "Wrap failed")
        );
        zap.wrap(zapData);
    }

}
