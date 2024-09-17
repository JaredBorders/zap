// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {ISpotMarketProxy} from "./../../../src/interfaces/ISpotMarketProxy.sol";

/// @title MockSpotMarketProxy contract for testing
/// @author JaredBorders (jaredborders@pm.me)
contract MockSpotMarketProxy is ISpotMarketProxy {

    bool public wrapShouldRevert;
    bool public unwrapShouldRevert;
    bool public sellShouldRevert;
    bool public buyShouldRevert;

    mapping(uint128 => address) public synthAddresses;

    function setWrapShouldRevert(bool _shouldRevert) external {
        wrapShouldRevert = _shouldRevert;
    }

    function setUnwrapShouldRevert(bool _shouldRevert) external {
        unwrapShouldRevert = _shouldRevert;
    }

    function setBuyShouldRevert(bool _shouldRevert) external {
        buyShouldRevert = _shouldRevert;
    }

    function setSellShouldRevert(bool _shouldRevert) external {
        sellShouldRevert = _shouldRevert;
    }

    function setSynthAddress(uint128 marketId, address synthAddress) external {
        synthAddresses[marketId] = synthAddress;
    }

    function name(uint128 /* marketId */ )
        external
        pure
        override
        returns (string memory)
    {
        return "MockName";
    }

    function getSynth(uint128 marketId)
        external
        view
        override
        returns (address)
    {
        return synthAddresses[marketId];
    }

    function wrap(
        uint128, /* marketId */
        uint256 wrapAmount,
        uint256 /* minAmountReceived */
    )
        external
        view
        override
        returns (uint256 amountToMint, Data memory fees)
    {
        require(!wrapShouldRevert, "Wrap failed");
        return (wrapAmount, Data(0, 0, 0, 0));
    }

    function unwrap(
        uint128, /* marketId */
        uint256 unwrapAmount,
        uint256 /* minAmountReceived */
    )
        external
        view
        override
        returns (uint256 returnCollateralAmount, Data memory fees)
    {
        require(!unwrapShouldRevert, "Unwrap failed");
        return (unwrapAmount, Data(0, 0, 0, 0));
    }

    function buy(
        uint128, /* marketId */
        uint256 usdAmount,
        uint256, /* minAmountReceived */
        address /* referrer */
    )
        external
        view
        override
        returns (uint256 synthAmount, Data memory fees)
    {
        require(!buyShouldRevert, "Buy failed");
        return (usdAmount, Data(0, 0, 0, 0));
    }

    function sell(
        uint128, /* marketId */
        uint256 synthAmount,
        uint256, /* minAmountReceived */
        address /* referrer */
    )
        external
        view
        override
        returns (uint256 usdAmountReceived, Data memory fees)
    {
        require(!sellShouldRevert, "Sell failed");
        return (synthAmount, Data(0, 0, 0, 0));
    }

}
