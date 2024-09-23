// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Arbitrum, Base} from "../script/utils/Parameters.sol";
import {
    ICore,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Zap
} from "../src/Zap.sol";
import {Test} from "forge-std/Test.sol";

contract ZapTest is Test, Arbitrum, Base {

    uint256 BASE;
    uint256 ARBITRUM;
    Zap zap;
    ISpotMarket spotMarket;
    IPerpsMarket perpsMarket;
    IERC20 usdc;
    IERC20 susdc;
    IERC20 usdx;
    IERC20 weth;
    address actor = 0x7777777777777777777777777777777777777777;
    uint256 tolerance = 0;

    function setUp() public {
        string memory BASE_RPC = vm.envString("BASE_RPC");
        string memory ARB_RPC = vm.envString("ARBITRUM_RPC");
        BASE = vm.createFork(BASE_RPC, 20_165_000);
        ARBITRUM = vm.createFork(ARB_RPC, 256_615_000);
    }

    modifier base() {
        vm.selectFork(BASE);
        zap = new Zap({
            _usdc: BASE_USDC,
            _usdx: BASE_USDX,
            _spotMarket: BASE_SPOT_MARKET,
            _perpsMarket: BASE_PERPS_MARKET,
            _core: BASE_CORE,
            _referrer: BASE_REFERRER,
            _susdcSpotId: BASE_SUSDC_SPOT_MARKET_ID,
            _aave: BASE_AAVE_POOL,
            _uniswap: BASE_UNISWAP
        });
        spotMarket = ISpotMarket(BASE_SPOT_MARKET);
        perpsMarket = IPerpsMarket(BASE_PERPS_MARKET);
        usdc = IERC20(BASE_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(BASE_USDX);
        weth = IERC20(0x4200000000000000000000000000000000000006);
        _;
    }

    modifier arbitrum() {
        vm.selectFork(ARBITRUM);
        zap = new Zap({
            _usdc: ARBITRUM_USDC,
            _usdx: ARBITRUM_USDX,
            _spotMarket: ARBITRUM_SPOT_MARKET,
            _perpsMarket: ARBITRUM_PERPS_MARKET,
            _core: ARBITRUM_CORE,
            _referrer: ARBITRUM_REFERRER,
            _susdcSpotId: ARBITRUM_SUSDC_SPOT_MARKET_ID,
            _aave: ARBITRUM_AAVE_POOL,
            _uniswap: ARBITRUM_UNISWAP
        });
        spotMarket = ISpotMarket(ARBITRUM_SPOT_MARKET);
        perpsMarket = IPerpsMarket(ARBITRUM_PERPS_MARKET);
        usdc = IERC20(ARBITRUM_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(ARBITRUM_USDX);
        weth = IERC20(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
        _;
    }

    function _spin(
        address addr,
        IERC20 token,
        uint256 amount,
        address approved
    )
        internal
    {
        vm.assume(amount > 1e6);
        deal(address(token), addr, amount);
        vm.prank(addr);
        IERC20(token).approve(approved, type(uint256).max);
    }

    function test_zap_in_arbitrum(uint32 amount) public arbitrum {
        _spin(actor, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(actor), amount);
        assertEq(usdx.balanceOf(actor), 0);
        vm.startPrank(actor);
        uint256 zapped = zap.zapIn({
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(zapped, tolerance);
        assertEq(usdc.balanceOf(actor), 0);
        assertEq(usdx.balanceOf(actor), zapped);
    }

    function test_zap_in_base(uint32 amount) public base {
        _spin(actor, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(actor), amount);
        assertEq(usdx.balanceOf(actor), 0);
        vm.startPrank(actor);
        uint256 zapped = zap.zapIn({
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(zapped, tolerance);
        assertEq(usdc.balanceOf(actor), 0);
        assertEq(usdx.balanceOf(actor), zapped);
    }

    function test_zap_out_arbitum(uint32 amount) public arbitrum {
        _spin(actor, usdx, amount, address(zap));
        assertEq(usdc.balanceOf(actor), 0);
        assertEq(usdx.balanceOf(actor), amount);
        vm.startPrank(actor);
        uint256 zapped = zap.zapOut({
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(zapped, tolerance);
        assertEq(usdc.balanceOf(actor), zapped);
        assertEq(usdx.balanceOf(actor), 0);
    }

    function test_zap_out_base(uint32 amount) public base {
        _spin(actor, usdx, amount, address(zap));
        assertEq(usdc.balanceOf(actor), 0);
        assertEq(usdx.balanceOf(actor), amount);
        vm.startPrank(actor);
        uint256 zapped = zap.zapOut({
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(zapped, tolerance);
        assertEq(usdc.balanceOf(actor), zapped);
        assertEq(usdx.balanceOf(actor), 0);
    }

    function test_wrap_arbitrum(uint32 amount) public arbitrum {
        _spin(actor, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(actor), amount);
        assertEq(susdc.balanceOf(actor), 0);
        vm.startPrank(actor);
        uint256 wrapped = zap.wrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(wrapped, tolerance);
        assertEq(usdc.balanceOf(actor), 0);
        assertEq(susdc.balanceOf(actor), wrapped);
    }

    function test_wrap_base(uint32 amount) public base {
        _spin(actor, usdc, amount, address(zap));
        assertEq(usdc.balanceOf(actor), amount);
        assertEq(susdc.balanceOf(actor), 0);
        vm.startPrank(actor);
        uint256 wrapped = zap.wrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(wrapped, tolerance);
        assertEq(usdc.balanceOf(actor), 0);
        assertEq(susdc.balanceOf(actor), wrapped);
    }

    function test_unwrap_arbitrum(uint32 amount) public arbitrum {
        _spin(actor, usdc, amount, address(zap));
        vm.startPrank(actor);
        uint256 wrapped = zap.wrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        assertEq(usdc.balanceOf(actor), 0);
        assertGe(susdc.balanceOf(actor), tolerance);
        susdc.approve(address(zap), type(uint256).max);
        uint256 unwrapped = zap.unwrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: wrapped,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(unwrapped, tolerance);
        assertEq(usdc.balanceOf(actor), amount);
        assertEq(susdc.balanceOf(actor), 0);
    }

    function test_unwrap_base(uint32 amount) public base {
        _spin(actor, usdc, amount, address(zap));
        vm.startPrank(actor);
        uint256 wrapped = zap.wrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        assertEq(usdc.balanceOf(actor), 0);
        assertGe(susdc.balanceOf(actor), tolerance);
        susdc.approve(address(zap), type(uint256).max);
        uint256 unwrapped = zap.unwrap({
            _token: address(usdc),
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: wrapped,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(unwrapped, tolerance);
        assertEq(usdc.balanceOf(actor), amount);
        assertEq(susdc.balanceOf(actor), 0);
    }

    function test_buy_arbitrum(uint32 amount) public arbitrum {
        _spin(actor, usdx, amount, address(zap));
        assertEq(usdx.balanceOf(actor), amount);
        assertEq(susdc.balanceOf(actor), 0);
        vm.startPrank(actor);
        (uint256 received, address synth) = zap.buy({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertEq(synth, address(susdc));
        assertGe(received, tolerance);
        assertEq(usdx.balanceOf(actor), 0);
        assertGe(susdc.balanceOf(actor), tolerance);
    }

    function test_sell_arbitrum(uint32 amount) public arbitrum {
        _spin(actor, usdx, amount, address(zap));
        vm.startPrank(actor);
        (uint256 received,) = zap.buy({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        assertEq(usdx.balanceOf(actor), 0);
        assertGe(susdc.balanceOf(actor), tolerance);
        susdc.approve(address(zap), type(uint256).max);
        received = zap.sell({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: received,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(received, tolerance);
        assertGe(usdx.balanceOf(actor), tolerance);
        assertEq(susdc.balanceOf(actor), 0);
    }

    function test_sell_base(uint32 amount) public base {
        _spin(actor, usdx, amount, address(zap));
        vm.startPrank(actor);
        (uint256 received,) = zap.buy({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        assertEq(usdx.balanceOf(actor), 0);
        assertGe(susdc.balanceOf(actor), tolerance);
        susdc.approve(address(zap), type(uint256).max);
        received = zap.sell({
            _synthId: zap.SUSDC_SPOT_ID(),
            _amount: received,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertGe(received, tolerance);
        assertGe(usdx.balanceOf(actor), tolerance);
        assertEq(susdc.balanceOf(actor), 0);
    }

    function test_swap_arbitrum() public arbitrum {
        uint256 amount = 1 ether;
        _spin(actor, weth, amount, address(zap));
        assertEq(weth.balanceOf(actor), amount);
        assertEq(usdc.balanceOf(actor), 0);
        vm.startPrank(actor);
        uint256 received = zap.swap({
            _from: address(weth),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertEq(weth.balanceOf(actor), 0);
        assertEq(usdc.balanceOf(actor), received);
        assertTrue(received > 0);
    }

    function test_swap_base() public arbitrum {
        uint256 amount = 1 ether;
        _spin(actor, weth, amount, address(zap));
        assertEq(weth.balanceOf(actor), amount);
        assertEq(usdc.balanceOf(actor), 0);
        vm.startPrank(actor);
        uint256 received = zap.swap({
            _from: address(weth),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: actor
        });
        vm.stopPrank();
        assertEq(weth.balanceOf(actor), 0);
        assertEq(usdc.balanceOf(actor), received);
        assertTrue(received > 0);
    }

    function test_flashloan() public arbitrum {
        /// @custom:todo
    }

}
