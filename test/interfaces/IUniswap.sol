// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

interface IRouter {

    function factory() external view returns (address);

}

interface IFactory {

    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    )
        external
        view
        returns (address pool);

}
