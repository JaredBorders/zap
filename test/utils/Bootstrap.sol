// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Arbitrum, Base} from "../../script/utils/Parameters.sol";
import {
    Errors,
    ICore,
    IERC20,
    IPerpsMarket,
    IPool,
    ISpotMarket,
    Reentrancy,
    Zap
} from "../../src/Zap.sol";
import {Constants} from "../utils/Constants.sol";
import {Test} from "forge-std/Test.sol";

contract Bootstrap is Test, Base, Arbitrum, Constants {

    uint256 BASE;
    uint256 ARBITRUM_A;
    uint256 ARBITRUM_B;

    Zap zap;

    ICore core;
    ISpotMarket spotMarket;
    IPerpsMarket perpsMarket;

    IERC20 usdc;
    IERC20 susdc;
    IERC20 usdx;
    IERC20 weth;

    function setUp() public {
        string memory BASE_RPC = vm.envString(BASE_RPC_REF);
        string memory ARBITRUM_RPC = vm.envString(ARBITRUM_RPC_REF);

        BASE = vm.createFork(BASE_RPC, BASE_FORK_BLOCK);
        ARBITRUM_A = vm.createFork(ARBITRUM_RPC, ARBITRUM_FORK_BLOCK);
        ARBITRUM_B = vm.createFork(ARBITRUM_RPC, ARBITRUM_FORK_BLOCK_DEBT);
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
        core = ICore(BASE_CORE);
        spotMarket = ISpotMarket(BASE_SPOT_MARKET);
        perpsMarket = IPerpsMarket(BASE_PERPS_MARKET);
        usdc = IERC20(BASE_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(BASE_USDX);
        weth = IERC20(BASE_WETH);
        _;
    }

    modifier arbitrum() {
        vm.selectFork(ARBITRUM_A);
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
        core = ICore(ARBITRUM_CORE);
        spotMarket = ISpotMarket(ARBITRUM_SPOT_MARKET);
        perpsMarket = IPerpsMarket(ARBITRUM_PERPS_MARKET);
        usdc = IERC20(ARBITRUM_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(ARBITRUM_USDX);
        weth = IERC20(ARBITRUM_WETH);
        _;
    }

    modifier arbitrum_b() {
        vm.selectFork(ARBITRUM_B);
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
        core = ICore(ARBITRUM_CORE);
        spotMarket = ISpotMarket(ARBITRUM_SPOT_MARKET);
        perpsMarket = IPerpsMarket(ARBITRUM_PERPS_MARKET);
        usdc = IERC20(ARBITRUM_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(ARBITRUM_USDX);
        weth = IERC20(ARBITRUM_WETH);
        _;
    }

    function _spin(
        address eoa,
        IERC20 token,
        uint256 amount,
        address approved
    )
        internal
    {
        vm.assume(amount > 1e6);
        deal(address(token), eoa, amount);
        vm.prank(eoa);
        IERC20(token).approve(approved, type(uint256).max);
    }

}
