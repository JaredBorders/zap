// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

contract ZapEvents {
    /// @notice emitted after successful $USDC -> $sUSD zap
    /// @param amount of $USDC wrapped and $sUSD minted
    event ZappedIn(uint256 amount);

    /// @notice emitted after successful $sUSD -> $USDC zap
    /// @param amount of $USDC unwrapped and $sUSD burned
    event ZappedOut(uint256 amount);
}
