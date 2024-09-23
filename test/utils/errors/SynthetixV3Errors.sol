// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

/// @title Cosolidated Errors from Synthetix v3 contracts
/// @author JaredBorders (jaredborders@pm.me)
contract SynthetixV3Errors {

    error WrapperExceedsMaxAmount(
        uint256 maxWrappableAmount, uint256 currentSupply, uint256 amountToWrap
    );

}
