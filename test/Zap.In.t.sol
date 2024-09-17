// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {Zap} from "../src/Zap.sol";
import {ZapErrors} from "../src/ZapErrors.sol";
import {ZapEvents} from "../src/ZapEvents.sol";

import {MockERC20} from "./utils/mocks/MockERC20.sol";
import {MockSpotMarketProxy} from "./utils/mocks/MockSpotMarketProxy.sol";
import {Test} from "forge-std/Test.sol";

contract ZapInTest is Test, ZapEvents {

    Zap public zap;
    MockERC20 public collateral;
    MockERC20 public synth;
    MockERC20 public sUSD;
    MockSpotMarketProxy public spotMarket;

    address public constant RECEIVER = address(0x123);
    address public constant REFERRER = address(0x456);
    uint128 public constant MARKET_ID = 1;
    uint128 public constant USD_SPOT_MARKET_ID = 0;
    uint256 public constant INITIAL_BALANCE = 1000e18;

    function setUp() public {
        zap = new Zap();
        collateral = new MockERC20("Collateral", "COL", 18);
        synth = new MockERC20("Synth", "SYN", 18);
        sUSD = new MockERC20("sUSD", "sUSD", 18);
        spotMarket = new MockSpotMarketProxy();

        // Set the synth address in the MockSpotMarketProxy
        spotMarket.setSynthAddress(MARKET_ID, address(synth));
        spotMarket.setSynthAddress(USD_SPOT_MARKET_ID, address(sUSD));

        // Setup initial balances and approvals
        collateral.mint(address(this), INITIAL_BALANCE);
        collateral.approve(address(zap), type(uint256).max);

        synth.mint(address(zap), INITIAL_BALANCE);
        sUSD.mint(address(zap), INITIAL_BALANCE);
    }

    function test_zapIn_success() public {
        uint256 amount = 100e18;
        uint256 expectedOutput = amount;

        Zap.ZapData memory zapData = Zap.ZapData({
            spotMarket: spotMarket,
            collateral: collateral,
            marketId: MARKET_ID,
            amount: amount,
            tolerance: Zap.Tolerance({
                tolerableWrapAmount: amount * 95 / 100,
                tolerableSwapAmount: expectedOutput * 95 / 100
            }),
            direction: Zap.Direction.In,
            receiver: RECEIVER,
            referrer: REFERRER
        });

        vm.expectEmit(true, true, true, true);
        emit ZapIn(address(this), MARKET_ID, amount, expectedOutput, RECEIVER);

        zap.zap(zapData);

        // Assert the final state
        assertEq(collateral.balanceOf(address(this)), INITIAL_BALANCE - amount);
        assertEq(sUSD.balanceOf(RECEIVER), expectedOutput);
    }

    function test_zapIn_wrapFailed() public {
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
                tolerableSwapAmount: amount * 95 / 100
            }),
            direction: Zap.Direction.In,
            receiver: RECEIVER,
            referrer: REFERRER
        });

        vm.expectRevert(
            abi.encodeWithSelector(ZapErrors.WrapFailed.selector, "Wrap failed")
        );
        zap.zap(zapData);
    }

    function test_zapIn_swapFailed() public {
        uint256 amount = 100e18;

        // Setup to make sell fail
        spotMarket.setSellShouldRevert(true);

        Zap.ZapData memory zapData = Zap.ZapData({
            spotMarket: spotMarket,
            collateral: collateral,
            marketId: MARKET_ID,
            amount: amount,
            tolerance: Zap.Tolerance({
                tolerableWrapAmount: amount * 95 / 100,
                tolerableSwapAmount: amount * 95 / 100
            }),
            direction: Zap.Direction.In,
            receiver: RECEIVER,
            referrer: REFERRER
        });

        vm.expectRevert(
            abi.encodeWithSelector(ZapErrors.SwapFailed.selector, "Sell failed")
        );
        zap.zap(zapData);
    }

}
