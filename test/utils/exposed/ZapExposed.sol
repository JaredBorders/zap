// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {Zap} from "src/Zap.sol";
import {ZapExposedEvents} from "./ZapExposedEvents.sol";

/// @title Exposed Zap contract used for testing and in the deploy script
/// @dev although it is used in the deploy script, it is
/// *not* safe and *not* meant for mainnet
/// @author JaredBorders (jaredborders@pm.me)
contract ZapExposed is Zap, ZapExposedEvents {
    function expose_HASHED_USDC_NAME() public pure returns (bytes32) {
        return HASHED_USDC_NAME;
    }

    function expose_USDC() public view returns (address) {
        return address(USDC);
    }

    function expose_SUSD() public view returns (address) {
        return address(SUSD);
    }

    function expose_SUSDC() public view returns (address) {
        return address(SUSDC);
    }

    function expose_SUSDC_SPOT_MARKET_ID() public view returns (uint128) {
        return SUSDC_SPOT_MARKET_ID;
    }

    function expose_SPOT_MARKET_PROXY() public view returns (address) {
        return address(SPOT_MARKET_PROXY);
    }

    constructor(
        address _usdc,
        address _susd,
        address _spotMarketProxy,
        uint128 _sUSDCId
    ) Zap(_usdc, _susd, _spotMarketProxy, _sUSDCId) {}

    function _preZap() internal override {
        emit PreZap();
    }

    function _postZap() internal override {
        emit PostZap();
    }
}
