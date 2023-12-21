// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import {Zap} from "src/Zap.sol";

/// @title Exposed Zap contract used for testing and in the deploy script
/// @dev although it is used in the deploy script, it is
/// *not* safe and *not* meant for mainnet
/// @author JaredBorders (jaredborders@pm.me)
contract ZapExposed is Zap {
    event PreZap();
    event PostZap();

    function expose_HASHED_USDC_NAME() public pure returns (bytes32) {
        return HASHED_USDC_NAME;
    }

    function expose_USDC() public view returns (address) {
        return address(USDC);
    }

    function expose_SUSD() public view returns (address) {
        return address(SUSD);
    }

    function expose_SPOT_MARKET_PROXY() public view returns (address) {
        return address(SPOT_MARKET_PROXY);
    }

    constructor(address _usdc, address _susd, address _spotMarketProxy)
        Zap(_usdc, _susd, _spotMarketProxy)
    {}

    function _preZap() internal override {
        emit PreZap();
    }

    function _postZap() internal override {
        emit PostZap();
    }

    function expose_verifySynthMarketId(uint128 _synthMarketId, bytes32 _hash)
        public view
    {
        super._verifySynthMarketId(_synthMarketId, _hash);
    }
}
