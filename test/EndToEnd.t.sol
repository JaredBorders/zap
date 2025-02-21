/// @custom:disabled no stata on arbitrum

// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.27;

// import {Arbitrum} from "../script/utils/Parameters.sol";
// import {IERC20, Zap} from "../src/Zap.sol";
// import {Flush} from "../src/utils/Flush.sol";
// import "./interfaces/ISynthetix.sol";

// import {Bootstrap} from "./utils/Bootstrap.sol";
// import {Constants} from "./utils/Constants.sol";
// import {OdosSwapData} from "./utils/OdosSwapData.sol";
// import "forge-std/Test.sol";

// interface IPyth {

//     struct PythPrice {
//         // Price
//         int64 price;
//         // Confidence interval around the price
//         uint64 conf;
//         // Price exponent
//         int32 expo;
//         // Unix timestamp describing when the price was published
//         uint256 publishTime;
//     }

//     function getPriceUnsafe(bytes32 id)
//         external
//         view
//         returns (PythPrice memory price);

// }

// contract Attacker {

//     IERC20 usdc;
//     address zap;

//     constructor(IERC20 _usdc, address _zap) {
//         usdc = _usdc;
//         zap = _zap;
//     }

//     function sweep(IERC20 token) public {
//         token.transfer(msg.sender, token.balanceOf(address(this)));
//     }

//     receive() external payable {
//         // could call back into zap to do another swap but that just pays
// more
//         // fees, no real profit
//         // could transfer usdc into zap for zap to be able to pay back the
//         // original caller but that is also just shuffling your own assets
//         // around
//         // cant call reenter into executeOperation because of access controls
//     }

// }

// contract EndToEndTest is Test, Arbitrum, Constants, OdosSwapData {

//     Zap zap;

//     ISpotMarket spotMarket;
//     IPerpsMarket perpsMarket;

//     IERC20 usdc;
//     IERC20 susdc;
//     IERC20 usdx;
//     IERC20 weth;

//     uint128 smallAccountIdNoOi =
//         170_141_183_460_469_231_731_687_303_715_884_106_052;
//     address smallAccountNoOiOwner =
// 0xbd400F9a17DC18bc031DBF5ffCD2689F4BF650dD;

//     uint128 smallAccountIdWithOi =
//         170_141_183_460_469_231_731_687_303_715_884_106_146;
//     address smallAccountWithOiOwner =
// 0x46232CbDB0512Ca7B00B8271e285BF8447F1330b;

//     uint128 largeAccountIdNoOi =
//         170_141_183_460_469_231_731_687_303_715_884_105_759;
//     address largeAccountNoOiOwner =
// 0x626a7d9f7bBCaEB1Fa88E8128Bec8f2Dd48b2b4d;

//     uint128 largeAccountIdWithOi =
//         170_141_183_460_469_231_731_687_303_715_884_105_846;
//     address largeAccountWithOiOwner =
// 0x1C1e747A6BE850549E9655addf59FD9e7cC2D4dC;

//     string RPC = vm.envString("ARBITRUM_RPC");
//     mapping(string => uint256) FORK;

//     modifier selectFork(uint256 fork) {
//         initilizeFork(fork);
//         _;
//     }

//     function setUp() public {
//         FORK["0p0001_wrong"] = vm.createFork(RPC, blockNumber_0p0001_wrong);
//         FORK["0p001_wrong"] = vm.createFork(RPC, blockNumber_0p001_wrong);
//         FORK["0p01_wrong"] = vm.createFork(RPC, blockNumber_0p01_wrong);
//         FORK["0p1_wrong"] = vm.createFork(RPC, blockNumber_0p1_wrong);
//         FORK["1_wrong"] = vm.createFork(RPC, blockNumber_1_wrong);
//         FORK["10_wrong"] = vm.createFork(RPC, blockNumber_10_wrong);
//         FORK["100_wrong"] = vm.createFork(RPC, blockNumber_100_wrong);

//         FORK["0p0001_zap"] = vm.createFork(RPC, blockNumber_0p0001_zap);
//         FORK["0p001_zap"] = vm.createFork(RPC, blockNumber_0p001_zap);
//         FORK["0p01_zap"] = vm.createFork(RPC, blockNumber_0p01_zap);
//         FORK["0p1_zap"] = vm.createFork(RPC, blockNumber_0p1_zap);
//         FORK["1_zap"] = vm.createFork(RPC, blockNumber_1_zap);
//         FORK["10_zap"] = vm.createFork(RPC, blockNumber_10_zap);
//         FORK["100_zap"] = vm.createFork(RPC, blockNumber_100_zap);

//         FORK["1000_attacker"] = vm.createFork(RPC,
// blockNumber_1000_attacker);
//     }

//     function initilizeFork(uint256 fork) public {
//         vm.selectFork(fork);

//         spotMarket = ISpotMarket(ARBITRUM_SPOT_MARKET);
//         perpsMarket = IPerpsMarket(ARBITRUM_PERPS_MARKET);

//         usdc = IERC20(ARBITRUM_USDC);
//         usdx = IERC20(ARBITRUM_USDX);
//         weth = IERC20(ARBITRUM_WETH);

//         uint128 synthMarketId = ARBITRUM_SUSDC_SPOT_MARKET_ID;

//         susdc = IERC20(spotMarket.getSynth(synthMarketId));

//         // create Zap contract to use actual sUSDC synth
//         zap = new Zap({
//             _usdc: address(usdc),
//             _usdx: address(usdx),
//             _sstata: address(0), // no stata on arbitrum
//             _spotMarket: address(spotMarket),
//             _perpsMarket: address(perpsMarket),
//             _referrer: ARBITRUM_REFERRER,
//             _susdcSpotId: synthMarketId,
//             _sstataSpotId: 0, // no stata on arbitrum
//             _aave: ARBITRUM_AAVE_POOL,
//             _stata: address(0), // no stata on arbitrum
//             _router: ARBITRUM_ROUTER
//         });

//         IPyth pyth = IPyth(0xd74CdD8Eef0E97a5a7678F907991316f88E7965A);

//         vm.mockCall(
//             address(pyth),
//             abi.encodeWithSignature(
//                 "getPriceUnsafe(bytes32)",
//                 0xeaa020c61cc479712813461ce153894a96a6c00b21ed0cfc2798d1f9a9e9c94a
//             ),
//             abi.encode(
//                 99_990_737,
//                 105_741,
//                 115_792_089_237_316_195_423_570_985_008_687_907_853_269_984_665_640_564_039_457_584_007_913_129_639_928,
//                 block.timestamp
//             )
//         );
//         vm.mockCall(
//             address(pyth),
//             abi.encodeWithSignature(
//                 "getPriceUnsafe(bytes32)",
//                 0x6ec879b1e9963de5ee97e9c8710b742d6228252a5e2ca12d4ae81d7fe5ee8c5d
//             ),
//             abi.encode(99_874_029, 139_807, int32(-8), block.timestamp)
//         );
//         vm.mockCall(
//             address(pyth),
//             abi.encodeWithSignature(
//                 "getPriceUnsafe(bytes32)",
//                 0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace
//             ),
//             abi.encode(314_393_291_700, 176_780_592, int32(-8),
// block.timestamp)
//         );
//         vm.mockCall(
//             address(pyth),
//             abi.encodeWithSignature(
//                 "getPriceUnsafe(bytes32)",
//                 0xd69731a2e74ac1ce884fc3890f7ee324b6deb66147055249568869ed700882e4
//             ),
//             abi.encode(191_914, 287, int32(-10), block.timestamp)
//         );
//         vm.mockCall(
//             address(pyth),
//             abi.encodeWithSignature(
//                 "getPriceUnsafe(bytes32)",
//                 0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43
//             ),
//             abi.encode(
//                 9_798_709_797_025, 5_649_852_176, int32(-8), block.timestamp
//             )
//         );
//     }

//     function _spin(address eoa, IERC20 token, uint256 amount) internal {
//         vm.assume(amount > 0);
//         deal(address(token), eoa, amount);
//     }

//     // this test fails because unspent input asses it not refunded
//     function testOdosSwapSmall_Success()
//         public
//         selectFork(FORK["0p0001_zap"])
//     {
//         address user = vm.addr(1);
//         uint256 amount = 1e18;
//         _spin(user, weth, amount);

//         uint256 wethBefore = weth.balanceOf(address(user));
//         uint256 usdcBefore = usdc.balanceOf(address(user));

//         vm.startPrank(user);
//         weth.approve(address(zap), amount);
//         zap.swapFrom(address(weth), swapData_0p0001_zap, amount, user);
//         vm.stopPrank();

//         assertEq(weth.balanceOf(address(user)), wethBefore - 0.0001 ether);
//         assertGt(
//             usdc.balanceOf(address(user)),
//             usdcBefore + ((1000 - 35) * outAmount_0p0001_zap / 1000)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testOdosSwapMedium_Success() public selectFork(FORK["1_zap"]) {
//         address user = vm.addr(1);
//         uint256 amount = 1e18;
//         _spin(user, weth, amount);

//         uint256 wethBefore = weth.balanceOf(address(user));
//         uint256 usdcBefore = usdc.balanceOf(address(user));

//         vm.startPrank(user);
//         weth.approve(address(zap), amount);
//         zap.swapFrom(address(weth), swapData_1_zap, amount, user);
//         vm.stopPrank();

//         assertEq(weth.balanceOf(address(user)), wethBefore - 1 ether);
//         assertGt(
//             usdc.balanceOf(address(user)),
//             usdcBefore + ((1000 - 35) * outAmount_1_zap / 1000)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testOdosSwapLarge_Success() public selectFork(FORK["10_zap"]) {
//         address user = vm.addr(1);
//         uint256 amount = 120e18;
//         _spin(user, weth, amount);

//         uint256 wethBefore = weth.balanceOf(address(user));
//         uint256 usdcBefore = usdc.balanceOf(address(user));

//         vm.startPrank(user);
//         weth.approve(address(zap), 100 ether);
//         zap.swapFrom(address(weth), swapData_10_zap, 10 ether, user);
//         vm.stopPrank();

//         assertEq(weth.balanceOf(address(user)), wethBefore - 10 ether);
//         assertGt(
//             usdc.balanceOf(address(user)),
//             usdcBefore + ((1000 - 35) * outAmount_10_zap / 1000)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     // this test fails because unspent input asset is not refunded
//     function testOdosSwapRepeat_Success() public selectFork(FORK["1_zap"]) {
//         // odos swap data can be repeated!
//         address user = vm.addr(1);
//         uint256 amount = 1e18;
//         _spin(user, weth, amount * 2);

//         uint256 wethBefore = weth.balanceOf(address(user));
//         uint256 usdcBefore = usdc.balanceOf(address(user));

//         vm.startPrank(user);
//         weth.approve(address(zap), amount);
//         zap.swapFrom(address(weth), swapData_1_zap, amount, user);
//         vm.stopPrank();

//         assertEq(weth.balanceOf(address(user)), wethBefore - 1 ether);
//         assertGe(
//             usdc.balanceOf(address(user)),
//             usdcBefore + ((1000 - 10) * outAmount_1_zap / 1000)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);

//         vm.startPrank(user);
//         weth.approve(address(zap), amount);
//         zap.swapFrom(address(weth), swapData_1_zap, amount, user);
//         vm.stopPrank();

//         assertEq(weth.balanceOf(address(user)), wethBefore - 2 ether);
//         assertGe(
//             usdc.balanceOf(address(user)),
//             usdcBefore + 2 * ((1000 - 10) * outAmount_1_zap / 1000)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testOdosSwapSendToWrongAddress_Fail()
//         public
//         selectFork(FORK["1_wrong"])
//     {
//         // failing because slippage exceeded
//         address user = vm.addr(1);
//         uint256 amount = 1e18;
//         _spin(user, weth, amount);

//         uint256 wethBefore = weth.balanceOf(address(user));
//         uint256 usdcBefore = usdc.balanceOf(address(user));

//         vm.startPrank(user);
//         weth.approve(address(zap), amount);

//         vm.expectRevert(bytes("ERC20: transfer amount exceeds balance"));
//         zap.swapFrom(address(weth), swapData_1_wrong, amount, user);
//         vm.stopPrank();

//         assertEq(weth.balanceOf(address(user)), wethBefore);
//         assertEq(usdc.balanceOf(address(user)), usdcBefore);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testOdosSwapSendToContract_Reentrancy_Success()
//         public
//         selectFork(FORK["10_attacker"])
//     {
//         Attacker attackerContract = new Attacker(usdc, address(zap));
//         uint256 amountUsdc = 1 ether; // non-realistic amount of USDC, but it
// is
//             // more to prove that the reentrancy is possible but not feasible
// or
//             // exploitable
//         address attacker = vm.addr(1234);

//         _spin(attacker, usdc, amountUsdc);

//         uint256 usdcBalBefore = usdc.balanceOf(attacker);
//         uint256 ethBalBefore = address(attackerContract).balance;
//         assertEq(ethBalBefore, 0);
//         assertEq(usdcBalBefore, amountUsdc);

//         vm.startPrank(attacker);
//         usdc.approve(address(zap), amountUsdc);
//         zap.swapFrom(address(usdc), swapData_10_attacker, amountUsdc,
// attacker);
//         vm.stopPrank();

//         uint256 ethBalAfter = address(attackerContract).balance;
//         uint256 usdcBalAfter = usdc.balanceOf(attacker);

//         assertGe(
//             ethBalAfter,
//             ethBalBefore + (1000 - 10) * outAmount_10_attacker / 1000
//         );

//         uint256 unrefundedUsdcZap = usdc.balanceOf(address(zap));
//         assertEq(unrefundedUsdcZap, 0);
//         // the final amounts are less than or equal to the amount provided
//         // initially, ie no profit
//         assertEq(usdcBalBefore, usdcBalAfter + inAmount_10_attacker);
//     }

//     function testUnwindSmallDebtNoOI_Overpay_AccountOwner_Success()
//         public
//         selectFork(FORK["0p01_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );

//         zap.unwind(
//             accountId,
//             4, // sETH collateral ID
//             collateralAmount,
//             address(weth),
//             swapData_0p01_zap,
//             0,
//             0,
//             0.01 ether,
//             address(this)
//         );
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(perpsMarket.totalCollateralValue(accountId), 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertFalse(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(
//             weth.balanceOf(address(this)),
//             wethBefore + collateralAmount - 0.01 ether
//         );
//         assertGt(
//             usdc.balanceOf(address(this)),
//             usdcBefore + ((1000 - 35) * outAmount_0p01_zap / 1000)
//                 - (debt / 1e12)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertLt(usdx.balanceOf(address(zap)), 1 ether);
//     }

//     function testUnwindSmallDebtWithOI_OverPay_AccountOwner_Success()
//         public
//         selectFork(FORK["0p01_zap"])
//     {
//         uint128 accountId = smallAccountIdWithOi;
//         address accountOwner = smallAccountWithOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertGt(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );

//         zap.unwind(
//             accountId,
//             4, // sETH collateral ID
//             0.01 ether,
//             address(weth),
//             swapData_0p01_zap,
//             0,
//             0,
//             0.01 ether,
//             address(this)
//         );
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(
//             perpsMarket.getCollateralAmount(accountId, 4),
//             collateralAmount - 0.01 ether
//         );
//         assertGt(
//             perpsMarket.totalCollateralValue(accountId),
//             tcvBefore - outValue_0p01_zap
//         ); // this check is weak because the oracle price on this block is
// diff
//             // from the odos api price
//         assertGt(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertFalse(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(weth.balanceOf(address(this)), wethBefore);
//         assertGt(
//             usdc.balanceOf(address(this)),
//             usdcBefore + ((1000 - 35) * outAmount_0p01_zap / 1000)
//                 - (debt / 1e12)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertLt(usdx.balanceOf(address(zap)), 1 ether);
//     }

//     function testUnwindSmallDebtNoOI_Underpay_AccountOwner_Fail()
//         public
//         selectFork(FORK["0p001_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );

//         vm.expectRevert(bytes("ERC20: transfer amount exceeds balance"));
//         zap.unwind(
//             accountId,
//             4, // sETH collateral ID
//             collateralAmount,
//             address(weth),
//             swapData_0p001_zap,
//             0,
//             0,
//             0.001 ether,
//             address(this)
//         );
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt);
//         assertEq(perpsMarket.totalCollateralValue(accountId), tcvBefore);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertTrue(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(weth.balanceOf(address(this)), wethBefore);
//         assertEq(usdc.balanceOf(address(this)), usdcBefore);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function
// testUnwindSmallDebtNoOI_Overpay_AccountOwner_OdosToWrongAddress_Fail(
//     )
//         public
//         selectFork(FORK["0p01_wrong"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );

//         vm.expectRevert(bytes("ERC20: transfer amount exceeds balance"));
//         zap.unwind(
//             accountId,
//             4, // sETH collateral ID
//             collateralAmount,
//             address(weth),
//             swapData_0p01_wrong,
//             0,
//             0,
//             0.01 ether,
//             address(this)
//         );
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt);
//         assertEq(perpsMarket.totalCollateralValue(accountId), tcvBefore);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertTrue(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(weth.balanceOf(address(this)), wethBefore);
//         assertEq(usdc.balanceOf(address(this)), usdcBefore);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     error NotPermitted();

//     function testUnwindSmallDebtNoOI_Overpay_NotAccountOwner_Fail()
//         public
//         selectFork(FORK["0p01_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );
//         vm.stopPrank();

//         vm.expectRevert(abi.encodeWithSelector(NotPermitted.selector));
//         zap.unwind(
//             accountId,
//             4,
//             collateralAmount,
//             address(weth),
//             swapData_0p001_zap,
//             0,
//             0,
//             0.001 ether,
//             address(this)
//         );

//         assertEq(perpsMarket.debt(accountId), debt);
//         assertEq(perpsMarket.totalCollateralValue(accountId), tcvBefore);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertTrue(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(weth.balanceOf(address(this)), wethBefore);
//         assertEq(usdc.balanceOf(address(this)), usdcBefore);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testUnwindSmallDebtNoOI_ZapNotPermitted_Fail()
//         public
//         selectFork(FORK["0p01_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         vm.expectRevert(
//             abi.encodeWithSelector(
//                 IPerpsMarket.PermissionDenied.selector,
//                 170_141_183_460_469_231_731_687_303_715_884_106_052,
//                 _PERPS_MODIFY_COLLATERAL_PERMISSION,
//                 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
//             )
//         );
//         zap.unwind(
//             accountId,
//             4,
//             collateralAmount,
//             address(weth),
//             swapData_0p001_zap,
//             0,
//             0,
//             0.001 ether,
//             address(this)
//         );
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt);
//         assertEq(perpsMarket.totalCollateralValue(accountId), tcvBefore);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertFalse(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(weth.balanceOf(address(this)), wethBefore);
//         assertEq(usdc.balanceOf(address(this)), usdcBefore);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     error OnlyAave(address);

//     function testUnwindFailDirectCallback()
//         public
//         selectFork(FORK["0p01_zap"])
//     {
//         vm.expectRevert(
//             abi.encodeWithSelector(OnlyAave.selector, address(this))
//         );
//         zap.executeOperation(address(0), 0, 0, address(0), "");
//     }

//     error ReentrancyDetected(uint8, uint8);

//     function testUnwindFailDirectCallbackInvalidOrigin()
//         public
//         selectFork(FORK["0p01_zap"])
//     {
//         vm.startPrank(ARBITRUM_AAVE_POOL);
//         vm.expectRevert(
//             abi.encodeWithSelector(ReentrancyDetected.selector, 0, 1)
//         );
//         zap.executeOperation(address(0), 0, 0, address(0), "");
//         vm.stopPrank();
//     }

//     function testUnwindLargeDebtNoOI_Overpay_AccountOwner_Success()
//         public
//         selectFork(FORK["10_zap"])
//     {
//         uint128 accountId = largeAccountIdNoOi;
//         address accountOwner = largeAccountNoOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );

//         zap.unwind(
//             accountId,
//             4, // sETH collateral ID
//             collateralAmount,
//             address(weth),
//             swapData_10_zap,
//             0,
//             0,
//             10 ether,
//             address(this)
//         );
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(perpsMarket.totalCollateralValue(accountId), 0);
//         assertEq(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertFalse(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(
//             weth.balanceOf(address(this)),
//             wethBefore + collateralAmount - 10 ether
//         );
//         assertGt(
//             usdc.balanceOf(address(this)),
//             usdcBefore + ((1000 - 2) * outAmount_10_zap / 1000) - (debt /
// 1e12)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertLt(usdx.balanceOf(address(zap)), 1 ether);
//     }

//     function testUnwindLargeDebtWithOI_OverPay_AccountOwner_Success()
//         public
//         selectFork(FORK["10_zap"])
//     {
//         uint128 accountId = largeAccountIdWithOi;
//         address accountOwner = largeAccountWithOiOwner;

//         uint256 tcvBefore = perpsMarket.totalCollateralValue(accountId);
//         uint256 debt = perpsMarket.debt(accountId);
//         uint256 collateralAmount = perpsMarket.getCollateralAmount(accountId,
// 4);
//         uint256 wethBefore = weth.balanceOf(address(this));
//         uint256 usdcBefore = usdc.balanceOf(address(this));

//         assertGt(tcvBefore, 0);
//         assertGt(debt, 0);
//         assertGt(perpsMarket.totalAccountOpenInterest(accountId), 0);

//         vm.startPrank(accountOwner);
//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );

//         zap.unwind(
//             accountId,
//             4, // sETH collateral ID
//             10 ether,
//             address(weth),
//             swapData_10_zap,
//             0,
//             0,
//             10 ether,
//             address(this)
//         );
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(
//             perpsMarket.getCollateralAmount(accountId, 4),
//             collateralAmount - 10 ether
//         );
//         assertGt(
//             perpsMarket.totalCollateralValue(accountId),
//             tcvBefore - outValue_10_zap
//         ); // this check is weak because the oracle price on this block is
// diff
//             // from the odos api price
//         assertGt(perpsMarket.totalAccountOpenInterest(accountId), 0);
//         assertFalse(
//             perpsMarket.hasPermission(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );

//         assertEq(weth.balanceOf(address(this)), wethBefore);
//         assertGt(
//             usdc.balanceOf(address(this)),
//             usdcBefore + ((1000 - 1) * outAmount_10_zap / 1000) - (debt /
// 1e12)
//         );

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertLt(usdx.balanceOf(address(zap)), 1 ether);
//     }

//     function testBurnSmallDebtNoOI_Exact_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtNoOI_Exact_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtNoOI_Overpay_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);
//         assertEq(usdx.balanceOf(accountOwner), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtNoOI_Overpay_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);
//         assertEq(usdx.balanceOf(user), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtNoOI_Partial_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address accountOwner = smallAccountNoOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(accountOwner), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtNoOI_Partial_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdNoOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(user), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtWithOI_Exact_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdWithOi;
//         address accountOwner = smallAccountWithOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtWithOI_Exact_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdWithOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtWithOI_Overpay_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdWithOi;
//         address accountOwner = smallAccountWithOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);
//         assertEq(usdx.balanceOf(accountOwner), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtWithOI_Overpay_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdWithOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);
//         assertEq(usdx.balanceOf(user), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtWithOI_Partial_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdWithOi;
//         address accountOwner = smallAccountWithOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(accountOwner), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnSmallDebtWithOI_Partial_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = smallAccountIdWithOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(user), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtNoOI_Exact_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdNoOi;
//         address accountOwner = largeAccountNoOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtNoOI_Exact_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdNoOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtNoOI_Overpay_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdNoOi;
//         address accountOwner = largeAccountNoOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);
//         assertEq(usdx.balanceOf(accountOwner), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtNoOI_Overpay_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdNoOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);
//         assertEq(usdx.balanceOf(user), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtNoOI_Partial_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdNoOi;
//         address accountOwner = largeAccountNoOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(accountOwner), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtNoOI_Partial_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdNoOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(user), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtWithOI_Exact_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdWithOi;
//         address accountOwner = largeAccountWithOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtWithOI_Exact_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdWithOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtWithOI_Overpay_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdWithOi;
//         address accountOwner = largeAccountWithOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(accountOwner), balanceBefore - debt);
//         assertEq(usdx.balanceOf(accountOwner), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtWithOI_Overpay_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdWithOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = 123_456_789 + debt;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), 0);
//         assertEq(usdx.balanceOf(user), balanceBefore - debt);
//         assertEq(usdx.balanceOf(user), 123_456_789);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtWithOI_Partial_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdWithOi;
//         address accountOwner = largeAccountWithOiOwner;

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(accountOwner, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(accountOwner);

//         vm.startPrank(accountOwner);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(accountOwner), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testBurnLargeDebtWithOI_Partial_NotAccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         uint128 accountId = largeAccountIdWithOi;
//         address user = vm.addr(1234);

//         // check account debt
//         uint256 debt = perpsMarket.debt(accountId);

//         uint256 amount = debt - 1e6;

//         _spin(user, usdx, amount);
//         uint256 balanceBefore = usdx.balanceOf(user);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);
//         zap.burn(amount, accountId);
//         vm.stopPrank();

//         assertEq(perpsMarket.debt(accountId), debt - balanceBefore);
//         assertEq(usdx.balanceOf(user), 0);

//         assertEq(weth.balanceOf(address(zap)), 0);
//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     // TODO fix plumber tests

//     function testFlush_Plumber_Success() public selectFork(FORK["1_zap"]) {
//         uint256 amountWeth = 1234 ether;
//         uint256 amountUsdx = 56_789 ether;
//         _spin(address(zap), weth, amountWeth);
//         _spin(address(zap), usdx, amountUsdx);

//         uint256 zapWethBefore = weth.balanceOf(address(zap));
//         uint256 zapUsdxBefore = usdx.balanceOf(address(zap));

//         uint256 plumberWethBefore = weth.balanceOf(address(this));
//         uint256 plumberUsdxBefore = usdx.balanceOf(address(this));

//         // this test contract created the Zap contract and should be the
// owner
//         zap.flush(address(usdx));

//         assertEq(usdx.balanceOf(address(zap)), 0);
//         assertEq(weth.balanceOf(address(zap)), zapWethBefore);

//         assertEq(
//             usdx.balanceOf(address(this)), plumberUsdxBefore + zapUsdxBefore
//         );
//         assertEq(weth.balanceOf(address(this)), plumberWethBefore);

//         zap.flush(address(weth));

//         assertEq(usdx.balanceOf(address(zap)), 0);
//         assertEq(weth.balanceOf(address(zap)), 0);

//         assertEq(
//             usdx.balanceOf(address(this)), plumberUsdxBefore + zapUsdxBefore
//         );
//         assertEq(
//             weth.balanceOf(address(this)), plumberWethBefore + zapWethBefore
//         );
//     }

//     error OnlyPlumber();

//     function testFlush_NotPlumberer_Fail() public selectFork(FORK["1_zap"]) {
//         uint256 amountWeth = 1234 ether;
//         uint256 amountUsdx = 56_789 ether;
//         _spin(address(zap), weth, amountWeth);
//         _spin(address(zap), usdx, amountUsdx);

//         uint256 zapWethBefore = weth.balanceOf(address(zap));
//         uint256 zapUsdxBefore = usdx.balanceOf(address(zap));

//         uint256 plumberWethBefore = weth.balanceOf(address(this));
//         uint256 plumberUsdxBefore = usdx.balanceOf(address(this));

//         // this test contract created the Zap contract and should be the
// owner
//         vm.prank(vm.addr(987_654_321));
//         vm.expectRevert(abi.encodeWithSelector(OnlyPlumber.selector));
//         zap.flush(address(usdx));

//         assertEq(usdx.balanceOf(address(zap)), zapUsdxBefore);
//         assertEq(weth.balanceOf(address(zap)), zapWethBefore);

//         assertEq(usdx.balanceOf(address(this)), plumberUsdxBefore);
//         assertEq(weth.balanceOf(address(this)), plumberWethBefore);
//     }

//     function testFlushNominate_Plumber_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address currentPlumber = zap.PLUMBER();
//         address nominated = address(0xdeadbeef);

//         assertGt(uint160(currentPlumber), 0);

//         zap.nominatePlumber(nominated);

//         address nominatedPlumber = zap.nominatedPlumber();
//         assertEq(nominatedPlumber, nominated);
//         assertEq(currentPlumber, zap.PLUMBER());

//         vm.prank(nominated);
//         zap.acceptPlumberNomination();
//         address newPlumber = zap.PLUMBER();
//         assertEq(nominated, newPlumber);
//     }

//     function testFlushDesignate_NotPlumber_Fail()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address currentPlumber = zap.PLUMBER();
//         address nominated = address(0);

//         assertGt(uint160(currentPlumber), 0);

//         vm.prank(vm.addr(987_654_321));
//         vm.expectRevert(abi.encodeWithSelector(OnlyPlumber.selector));
//         zap.nominatePlumber(nominated);

//         address newPlumber = zap.PLUMBER();
//         assertEq(newPlumber, currentPlumber);
//         assertGt(uint160(newPlumber), 0);
//     }

//     function testWithdrawNoOiNoDebt_AllCollateral_AccountOwner_Success()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address user = vm.addr(5);
//         uint32 amount = 1_000_000_000;
//         _spin(user, usdx, amount);

//         vm.startPrank(user);
//         uint128 accountId = perpsMarket.createAccount();
//         int128 margin = int128(int32(amount));

//         usdx.approve(address(perpsMarket), amount);
//         perpsMarket.modifyCollateral(accountId, 0, margin);

//         assertEq(usdx.balanceOf(user), 0);
//         assertEq(perpsMarket.totalCollateralValue(accountId), amount);

//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );
//         zap.withdraw({
//             _synthId: 0,
//             _amount: amount,
//             _accountId: accountId,
//             _receiver: user
//         });
//         vm.stopPrank();

//         assertEq(usdx.balanceOf(user), amount);
//         assertEq(perpsMarket.totalCollateralValue(accountId), 0);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//         assertFalse(
//             perpsMarket.isAuthorized(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );
//     }

//     function testWithdrawNoOiNoDebt_AllCollateral_NotAccounttOwner_Fail()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address user = vm.addr(5);
//         uint32 amount = 1_000_000_000;
//         _spin(user, usdx, amount);

//         vm.startPrank(user);
//         uint128 accountId = perpsMarket.createAccount();
//         int128 margin = int128(int32(amount));

//         usdx.approve(address(perpsMarket), amount);
//         perpsMarket.modifyCollateral(accountId, 0, margin);

//         assertEq(usdx.balanceOf(user), 0);

//         perpsMarket.grantPermission(
//             accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//         );
//         vm.stopPrank();

//         vm.expectRevert(abi.encodeWithSelector(NotPermitted.selector));
//         zap.withdraw({
//             _synthId: 0,
//             _amount: amount,
//             _accountId: accountId,
//             _receiver: user
//         });

//         assertEq(usdx.balanceOf(user), 0);
//         assertEq(perpsMarket.totalCollateralValue(accountId), amount);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//         assertTrue(
//             perpsMarket.isAuthorized(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );
//     }

//     function testWithdrawNoOiNoDebt_AccountOwner_ZapNotPermitted_Fail()
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address user = vm.addr(5);
//         uint32 amount = 1_000_000_000;
//         _spin(user, usdx, amount);

//         vm.startPrank(user);
//         uint128 accountId = perpsMarket.createAccount();
//         int128 margin = int128(int32(amount));

//         usdx.approve(address(perpsMarket), amount);
//         perpsMarket.modifyCollateral(accountId, 0, margin);

//         assertEq(usdx.balanceOf(user), 0);
//         assertEq(perpsMarket.totalCollateralValue(accountId), amount);

//         vm.expectRevert(
//             abi.encodeWithSelector(
//                 IPerpsMarket.PermissionDenied.selector,
//                 accountId,
//                 _PERPS_MODIFY_COLLATERAL_PERMISSION,
//                 address(zap)
//             )
//         );
//         zap.withdraw({
//             _synthId: 0,
//             _amount: amount,
//             _accountId: accountId,
//             _receiver: user
//         });

//         vm.stopPrank();

//         assertEq(usdx.balanceOf(user), 0);
//         assertEq(perpsMarket.totalCollateralValue(accountId), amount);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//         assertFalse(
//             perpsMarket.isAuthorized(
//                 accountId, _PERPS_MODIFY_COLLATERAL_PERMISSION, address(zap)
//             )
//         );
//     }

//     // Basic functional tests, these are similar to existing tests and were
// used
//     // to ensure this harness worked correctly
//     function testBuySuccess(uint128 amount) public selectFork(FORK["1_zap"])
// {
//         // D18, fuzzing up to 3e38
//         vm.assume(amount < uint128(type(int128).max / 9));
//         vm.assume(amount > 10);

//         address user = vm.addr(1);
//         // uint256 amount = 1000e6;

//         _spin(user, usdx, amount);

//         assertEq(usdx.balanceOf(user), amount);
//         assertEq(susdc.balanceOf(user), 0);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);

//         (uint256 received, address synth) = zap.buy({
//             _synthId: zap.SSTATA_SPOT_ID(),
//             _amount: amount,
//             _minAmountOut: 0,
//             _receiver: user
//         });
//         vm.stopPrank();

//         assertEq(synth, address(susdc));
//         assertGe(received, amount * 9 / 10);
//         assertEq(usdx.balanceOf(user), 0);
//         assertGe(susdc.balanceOf(user), amount * 9 / 10);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testSellSuccess( /*uint128 amount*/ )
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address user = vm.addr(2);
//         // _maxCoreCapacity();
//         // vm.assume(amount < 1e20);
//         uint256 amount = 1000e18;
//         uint256 minAmountOut = amount * 99 / 100;
//         _spin(user, usdx, amount);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);

//         (uint256 received,) = zap.buy({
//             _synthId: zap.SSTATA_SPOT_ID(),
//             _amount: amount,
//             _minAmountOut: minAmountOut,
//             _receiver: user
//         });

//         assertEq(usdx.balanceOf(user), 0);
//         assertEq(usdc.balanceOf(user), 0);
//         assertEq(susdc.balanceOf(user), received);
//         assertGe(received, minAmountOut);
//         assertGe(susdc.balanceOf(user), minAmountOut);

//         susdc.approve(address(zap), received);
//         minAmountOut = received * 99 / 100;

//         received = zap.sell({
//             _synthId: zap.SSTATA_SPOT_ID(),
//             _amount: received,
//             _minAmountOut: minAmountOut,
//             _receiver: user
//         });
//         vm.stopPrank();

//         assertGe(usdx.balanceOf(user), minAmountOut);
//         assertGe(received, minAmountOut);
//         assertEq(usdx.balanceOf(user), received);
//         assertEq(susdc.balanceOf(user), 0);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testUnwrap( /* uint32 amount */ )
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address user = vm.addr(4);
//         uint256 amount = 1000e6;
//         _spin(user, usdc, amount);

//         vm.startPrank(user);
//         usdc.approve(address(zap), amount);

//         uint256 wrapped = zap.wrap({
//             _token: address(usdc),
//             _synthId: zap.SSTATA_SPOT_ID(),
//             _amount: amount,
//             _minAmountOut: amount,
//             _receiver: user
//         });

//         assertEq(usdc.balanceOf(user), 0);
//         assertEq(wrapped, amount * 1e12);
//         assertEq(susdc.balanceOf(user), amount * 1e12);

//         susdc.approve(address(zap), type(uint256).max);

//         uint256 unwrapped = zap.unwrap({
//             _token: address(usdc),
//             _synthId: zap.SSTATA_SPOT_ID(),
//             _amount: wrapped,
//             _minAmountOut: amount,
//             _receiver: user
//         });
//         vm.stopPrank();

//         assertEq(unwrapped, amount);
//         assertEq(usdc.balanceOf(user), amount);
//         assertEq(susdc.balanceOf(user), 0);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testWrap( /*uint64 amount*/ ) public selectFork(FORK["1_zap"]) {
//         address user = vm.addr(6);
//         uint64 amount = 1000e6;
//         _spin(user, usdc, amount);

//         assertEq(usdc.balanceOf(user), amount);
//         assertEq(susdc.balanceOf(user), 0);

//         vm.startPrank(user);
//         usdc.approve(address(zap), amount);

//         uint256 wrapped = zap.wrap({
//             _token: address(usdc),
//             _synthId: zap.SSTATA_SPOT_ID(),
//             _amount: amount,
//             _minAmountOut: amount,
//             _receiver: user
//         });
//         vm.stopPrank();

//         assertEq(wrapped, uint256(amount) * 1e12);
//         assertEq(usdc.balanceOf(user), 0);
//         assertEq(susdc.balanceOf(user), wrapped);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testZapInSuccess( /*uint64 amount*/ )
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address user = vm.addr(7);
//         uint64 amount = 1000e6;
//         _spin(user, usdc, amount);

//         assertEq(usdc.balanceOf(user), amount);
//         assertEq(usdx.balanceOf(user), 0);

//         vm.startPrank(user);
//         usdc.approve(address(zap), amount);

//         uint256 zapped =
//             zap.zapIn({_amount: amount, _minAmountOut: amount, _receiver:
// user});
//         vm.stopPrank();

//         assertGe(zapped, uint256(amount) * 99e10); // amount * 1e12 * 0.99
//         assertEq(usdc.balanceOf(user), 0);
//         assertEq(usdx.balanceOf(user), zapped);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

//     function testZapOutSuccess( /*uint64 amount*/ )
//         public
//         selectFork(FORK["1_zap"])
//     {
//         address user = vm.addr(8);
//         // vm.assume(amount > 1e12);
//         uint256 amount = 250e18;
//         _spin(address(this), usdc, amount / 1e12);
//         usdc.approve(address(zap), amount / 1e12);
//         zap.wrap({
//             _token: address(usdc),
//             _synthId: zap.SSTATA_SPOT_ID(),
//             _amount: amount / 1e12,
//             _minAmountOut: amount / 1e12,
//             _receiver: address(this)
//         });
//         assertEq(usdc.balanceOf(address(this)), 0);
//         assertEq(susdc.balanceOf(address(this)), amount);

//         _spin(user, usdx, amount);

//         assertEq(usdc.balanceOf(user), 0);
//         assertEq(usdx.balanceOf(user), amount);

//         vm.startPrank(user);
//         usdx.approve(address(zap), amount);

//         uint256 zapped = zap.zapOut({
//             _amount: amount,
//             _minAmountOut: amount * 9 / 1e13,
//             _receiver: user
//         });
//         vm.stopPrank();

//         assertGe(zapped * 1e12, amount * 9 / 10);
//         assertEq(usdc.balanceOf(user), zapped);
//         assertEq(usdx.balanceOf(user), 0);

//         assertEq(usdc.balanceOf(address(zap)), 0);
//         assertEq(susdc.balanceOf(address(zap)), 0);
//         assertEq(usdx.balanceOf(address(zap)), 0);
//     }

// }
