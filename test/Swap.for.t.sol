// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {
    Bootstrap,
    Constants,
    IERC20,
    IFactory,
    IFactory,
    IPerpsMarket,
    IPool,
    IRouter,
    ISpotMarket,
    Test,
    Zap
} from "./utils/Bootstrap.sol";

contract SwapForTest is Bootstrap {

    function test_swap_for_base() public base {
        uint256 amount = 100e6;
        uint256 tolerance = type(uint256).max / 4;
        _spin(ACTOR, weth, tolerance, address(zap));
        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(weth.balanceOf(ACTOR), tolerance);
        vm.startPrank(ACTOR);
        zap.swapFor({
            _from: address(weth),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: ACTOR
        });
        assertGt(usdc.balanceOf(ACTOR), 0);
        assertLt(weth.balanceOf(ACTOR), tolerance);
        vm.stopPrank();
    }

    function test_swap_for_arbitrum(uint8 percentage) public arbitrum {
        vm.assume(percentage < 95 && percentage > 0);

        uint256 tolerance = type(uint256).max;
        _spin(ACTOR, weth, tolerance, address(zap));

        address pool = IFactory(IRouter(zap.ROUTER()).factory()).getPool(
            address(weth), address(usdc), zap.FEE_TIER()
        );
        uint256 depth = usdc.balanceOf(pool);
        uint256 amount = depth * (percentage / 100);

        assertEq(usdc.balanceOf(ACTOR), 0);
        assertEq(weth.balanceOf(ACTOR), tolerance);

        vm.startPrank(ACTOR);

        if (amount == 0) {
            vm.expectRevert();
        }

        zap.swapFor({
            _from: address(weth),
            _amount: amount,
            _tolerance: tolerance,
            _receiver: ACTOR
        });

        assertTrue(
            amount > 1e6
                ? usdc.balanceOf(ACTOR) < 0
                : usdc.balanceOf(ACTOR) == 0
        );
        assertLe(weth.balanceOf(ACTOR), tolerance);

        vm.stopPrank();
    }

    /// @custom:todo
    function test_swap_for_arbitrum_sepolia() public arbitrum_sepolia {}

    bytes32 internal constant POOL_INIT_CODE_HASH =
        0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;

    struct PoolKey {
        address token0;
        address token1;
        uint24 fee;
    }

    function getPoolKey(
        address tokenA,
        address tokenB,
        uint24 fee
    )
        internal
        pure
        returns (PoolKey memory)
    {
        if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
        return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
    }

    function computeAddress(
        address factory,
        PoolKey memory key
    )
        internal
        pure
        returns (address pool)
    {
        require(key.token0 < key.token1);
        uint256 pool256 = uint256(
            keccak256(
                abi.encodePacked(
                    hex"ff",
                    factory,
                    keccak256(abi.encode(key.token0, key.token1, key.fee)),
                    POOL_INIT_CODE_HASH
                )
            )
        );
        assembly {
            pool := shr(96, pool256)
        }
    }

}
