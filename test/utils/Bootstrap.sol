// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Deploy} from "../../script/Deploy.s.sol";
import {Base, BaseSepolia} from "../../script/utils/Parameters.sol";
import {Errors, IERC20, IPool, Reentrancy, Zap} from "../../src/Zap.sol";
import {IPerpsMarket, ISpotMarket} from "../interfaces/ISynthetix.sol";

import {Constants} from "../utils/Constants.sol";

import {stdJson} from "forge-std/StdJson.sol";
import {Test} from "forge-std/Test.sol";
import {Surl} from "surl/src/Surl.sol";

contract Bootstrap is Test, Deploy, Base, BaseSepolia, Constants {

    using Surl for *;
    using stdJson for string;

    /// @custom:forks
    uint256 BASE;
    uint256 BASE_SEPOLIA;

    /// @custom:target
    Zap zap;

    /// @custom:auxiliary
    ISpotMarket spotMarket;
    IPerpsMarket perpsMarket;
    IERC20 usdc;
    IERC20 susdc;
    IERC20 usdx;
    IERC20 sstata;
    IERC20 weth;
    IERC20 tbtc;

    string[] headers;

    function setUp() public virtual {
        string memory BASE_RPC = vm.envString(BASE_RPC_REF);
        string memory BASE_SEPOLIA_RPC = vm.envString(BASE_SEPOLIA_RPC_REF);

        BASE = vm.createFork(BASE_RPC, BASE_FORK_BLOCK);
        BASE_SEPOLIA = vm.createFork(BASE_SEPOLIA_RPC /* , BASE_SEPOLIA_FORK_BLOCK */);

        headers.push("Content-Type: application/json");
    }

    modifier base() {
        /// @custom:fork
        vm.selectFork(BASE);

        /// @custom:target
        zap = deploySystem({
            usdc: BASE_USDC,
            usdx: BASE_USDX,
            sstata: BASE_SSTATA,
            spotMarket: BASE_SPOT_MARKET,
            perpsMarket: BASE_PERPS_MARKET,
            referrer: BASE_REFERRER,
            susdcSpotId: BASE_SUSDC_SPOT_MARKET_ID,
            sstataSpotId: BASE_SSTATA_SPOT_MARKET_ID,
            aave: BASE_AAVE_POOL,
            stata: BASE_STATA,
            router: BASE_ROUTER
        });

        /// @custom:auxiliary
        spotMarket = ISpotMarket(BASE_SPOT_MARKET);
        perpsMarket = IPerpsMarket(BASE_PERPS_MARKET);
        usdc = IERC20(BASE_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SUSDC_SPOT_ID()));
        usdx = IERC20(BASE_USDX);
        sstata = IERC20(BASE_SSTATA);
        weth = IERC20(BASE_WETH);
        tbtc = IERC20(BASE_TBTC);

        _;
    }

    modifier base_sepolia() {
        /// @custom:fork
        vm.selectFork(BASE_SEPOLIA);

        /// @custom:target
        zap = deploySystem({
            usdc: BASE_SEPOLIA_USDC,
            usdx: BASE_SEPOLIA_USDX,
            sstata: address(0), //todo we are not deploying this stata release
                // to base
            spotMarket: BASE_SEPOLIA_SPOT_MARKET,
            perpsMarket: BASE_SEPOLIA_PERPS_MARKET,
            referrer: BASE_SEPOLIA_REFERRER,
            susdcSpotId: BASE_SEPOLIA_SUSDC_SPOT_MARKET_ID,
            sstataSpotId: 0, //todo we are not deploying this stata release to
                // base
            aave: BASE_SEPOLIA_AAVE_POOL,
            stata: address(0), //todo we are not deploying this stata release to
                // base
            router: BASE_SEPOLIA_ROUTER
        });

        /// @custom:auxiliary
        spotMarket = ISpotMarket(BASE_SEPOLIA_SPOT_MARKET);
        perpsMarket = IPerpsMarket(BASE_SEPOLIA_PERPS_MARKET);
        usdc = IERC20(BASE_SEPOLIA_USDC);
        susdc = IERC20(spotMarket.getSynth(zap.SSTATA_SPOT_ID()));
        usdx = IERC20(BASE_SEPOLIA_USDX);
        weth = IERC20(BASE_SEPOLIA_WETH);

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

    function getOdosQuoteParams(
        uint256 chainId,
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 proportionOut,
        uint256 slippageLimitPct,
        address userAddress
    )
        internal
        returns (string memory)
    {
        return string.concat(
            '{"chainId": ',
            vm.toString(chainId),
            ', "inputTokens": [{"tokenAddress": "',
            vm.toString(tokenIn),
            '", "amount": "',
            vm.toString(amountIn),
            '"}],"outputTokens": [{"tokenAddress": "',
            vm.toString(tokenOut),
            '", "proportion": ',
            vm.toString(proportionOut),
            '}], "slippageLimitPercent": ',
            vm.toString(slippageLimitPct),
            ', "userAddr": "',
            vm.toString(userAddress),
            '"}'
        );
    }

    function getOdosQuote(
        uint256 chainId,
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 proportionOut,
        uint256 slippageLimitPct,
        address userAddress
    )
        internal
        returns (uint256 status, bytes memory data)
    {
        string memory params = getOdosQuoteParams(
            chainId,
            tokenIn,
            amountIn,
            tokenOut,
            proportionOut,
            slippageLimitPct,
            userAddress
        );

        (status, data) = ODOS_QUOTE_URL.post(headers, params);
    }

    function getOdosQuotePathId(
        uint256 chainId,
        address tokenIn,
        uint256 amountIn,
        address tokenOut
    )
        internal
        returns (string memory pathId)
    {
        (, bytes memory data) = getOdosQuote(
            chainId,
            tokenIn,
            amountIn,
            tokenOut,
            DEFAULT_PROPORTION,
            DEFAULT_SLIPPAGE,
            address(zap)
        );
        pathId = abi.decode(vm.parseJson(string(data), ".pathId"), (string));
    }

    function getOdosAssembleParams(string memory pathId)
        internal
        returns (string memory)
    {
        return string.concat(
            '{"userAddr": "',
            vm.toString(address(zap)),
            '", "pathId": "',
            pathId,
            '"}'
        );
    }

    function odosAssemble(string memory pathId)
        internal
        returns (uint256 status, bytes memory data)
    {
        string memory params = getOdosAssembleParams(pathId);

        (status, data) = ODOS_ASSEMBLE_URL.post(headers, params);
    }

    function getAssemblePath(string memory pathId)
        internal
        returns (bytes memory swapPath)
    {
        bytes memory assembleData;
        {
            (, assembleData) = odosAssemble(pathId);
        }
        bytes memory transaction = string(assembleData).parseRaw(".transaction");
        Transaction memory rawTxDetail = abi.decode(transaction, (Transaction));
        return rawTxDetail.data;
    }

}
