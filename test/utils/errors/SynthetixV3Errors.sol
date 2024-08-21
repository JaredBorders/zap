// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

/// @title Cosolidated Errors from Synthetix v3 contracts
/// @author JaredBorders (jaredborders@pm.me)
contract SynthetixV3Errors {

    error WrapperExceedsMaxAmount(
        uint256 maxWrappableAmount, uint256 currentSupply, uint256 amountToWrap
    );

}
