// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

interface IERC4626 {

    function approve(address spender, uint256 amount) external returns (bool);

    function deposit(
        uint256 assets,
        address receiver
    )
        external
        returns (uint256 shares);

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    )
        external
        returns (uint256 assets);

}
