// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Deploy} from "../../script/Deploy.s.sol";
import {
    Arbitrum, ArbitrumSepolia, Base
} from "../../script/utils/Parameters.sol";
import {Errors, IERC20, IPool, Reentrancy, Zap} from "../../src/Zap.sol";
import {IPerpsMarket, ISpotMarket} from "../interfaces/ISynthetix.sol";

import {IFactory, IRouter} from "../interfaces/IUniswap.sol";
import {Constants} from "../utils/Constants.sol";
import {Test} from "forge-std/Test.sol";

contract Bootstrap is
    Test,
    Deploy,
    Base,
    Arbitrum,
    ArbitrumSepolia,
    Constants
{

    /// @custom:forks
    uint256 BASE;
    uint256 ARBITRUM;
    uint256 ARBITRUM_SEPOLIA;

    /// @custom:target
    Zap zap;

    /// @custom:auxiliary
    ISpotMarket spotMarket;
    IPerpsMarket perpsMarket;
    IERC20 usdc;
    IERC20 susdc;
    IERC20 usdx;
    IERC20 weth;

    function setUp() public {
        string memory BASE_RPC = vm.envString(BASE_RPC_REF);
        string memory ARBITRUM_RPC = vm.envString(ARBITRUM_RPC_REF);
        string memory ARBITRUM_SEPOLIA_RPC =
            vm.envString(ARBITRUM_SEPOLIA_RPC_REF);

        BASE = vm.createFork(BASE_RPC, BASE_FORK_BLOCK);
        ARBITRUM = vm.createFork(ARBITRUM_RPC, ARBITRUM_FORK_BLOCK);
        ARBITRUM_SEPOLIA =
            vm.createFork(ARBITRUM_SEPOLIA_RPC, ARBITRUM_SEPOLIA_FORK_BLOCK);
    }

    modifier base() {
        /// @custom:fork
        vm.selectFork(BASE);

        /// @custom:target
        zap = deploySystem({
            usdc: BASE_USDC,
            usdx: BASE_USDX,
            spotMarket: BASE_SPOT_MARKET,
            perpsMarket: BASE_PERPS_MARKET,
            referrer: BASE_REFERRER,
            susdcSpotId: BASE_SUSDC_SPOT_MARKET_ID,
            aave: BASE_AAVE_POOL,
            router: BASE_ROUTER,
            quoter: BASE_QUOTER
        });

        /// @custom:auxiliary
        spotMarket = ISpotMarket(BASE_SPOT_MARKET);
        perpsMarket = IPerpsMarket(BASE_PERPS_MARKET);
        usdc = IERC20(BASE_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(BASE_USDX);
        weth = IERC20(BASE_WETH);

        _;
    }

    modifier arbitrum() {
        /// @custom:fork
        vm.selectFork(ARBITRUM);

        /// @custom:target
        zap = deploySystem({
            usdc: ARBITRUM_USDC,
            usdx: ARBITRUM_USDX,
            spotMarket: ARBITRUM_SPOT_MARKET,
            perpsMarket: ARBITRUM_PERPS_MARKET,
            referrer: ARBITRUM_REFERRER,
            susdcSpotId: ARBITRUM_SUSDC_SPOT_MARKET_ID,
            aave: ARBITRUM_AAVE_POOL,
            router: ARBITRUM_ROUTER,
            quoter: ARBITRUM_QUOTER
        });

        /// @custom:auxiliary
        spotMarket = ISpotMarket(ARBITRUM_SPOT_MARKET);
        perpsMarket = IPerpsMarket(ARBITRUM_PERPS_MARKET);
        usdc = IERC20(ARBITRUM_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(ARBITRUM_USDX);
        weth = IERC20(ARBITRUM_WETH);

        _;
    }

    modifier arbitrum_sepolia() {
        /// @custom:fork
        vm.selectFork(ARBITRUM_SEPOLIA);

        /// @custom:target
        zap = deploySystem({
            usdc: ARBITRUM_SEPOLIA_USDC,
            usdx: ARBITRUM_SEPOLIA_USDX,
            spotMarket: ARBITRUM_SEPOLIA_SPOT_MARKET,
            perpsMarket: ARBITRUM_SEPOLIA_PERPS_MARKET,
            referrer: ARBITRUM_SEPOLIA_REFERRER,
            susdcSpotId: ARBITRUM_SEPOLIA_SUSDC_SPOT_MARKET_ID,
            aave: ARBITRUM_SEPOLIA_AAVE_POOL,
            router: ARBITRUM_SEPOLIA_ROUTER,
            quoter: ARBITRUM_SEPOLIA_QUOTER
        });

        /// @custom:auxiliary
        spotMarket = ISpotMarket(ARBITRUM_SEPOLIA_SPOT_MARKET);
        perpsMarket = IPerpsMarket(ARBITRUM_SEPOLIA_PERPS_MARKET);
        usdc = IERC20(ARBITRUM_SEPOLIA_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(ARBITRUM_SEPOLIA_USDX);
        weth = IERC20(ARBITRUM_SEPOLIA_WETH);

        _;
    }

    /// @notice "spin" up an EOA with some tokens and approvals
    /// @dev "assumes" a minimum amount thereby muffling fuzzing noise
    /// @param eoa to spin up
    /// @param token that will be sent (i.e., dealt) to the EOA
    /// @param amount of tken to send to the EOA
    /// @param approved address granted max allowance by the EOA
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
