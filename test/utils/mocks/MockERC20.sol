// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {IERC20} from "./../../../src/interfaces/IERC20.sol";

/// @title MockERC20 contract for testing
/// @dev Implements ERC20 standard with extra state modification functions
/// @author JaredBorders (jaredborders@pm.me)
contract MockERC20 is IERC20 {

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function approve(
        address spender,
        uint256 amount
    )
        public
        override
        returns (bool)
    {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(
        address to,
        uint256 amount
    )
        public
        override
        returns (bool)
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    )
        public
        override
        returns (bool)
    {
        uint256 allowed = allowance[from][msg.sender];
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
        }
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function mint(address to, uint256 amount) public {
        totalSupply += amount;
        balanceOf[to] += amount;
    }

    function burn(address from, uint256 amount) public {
        balanceOf[from] -= amount;
        totalSupply -= amount;
    }

    function setAllowance(
        address owner,
        address spender,
        uint256 amount
    )
        public
    {
        allowance[owner][spender] = amount;
    }

}
