# Zap Flashloan Utility

[![Github Actions][gha-badge]][gha] 
[![Foundry][foundry-badge]][foundry] 
[![License: GPL-3.0][license-badge]][license]

[gha]: https://github.com/JaredBorders/Zap/actions
[gha-badge]: https://github.com/JaredBorders/Zap/actions/workflows/test.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/license/GPL-3.0/
[license-badge]: https://img.shields.io/badge/GitHub-GPL--3.0-informational

## Overview

Zap is a smart contract that facilitates stablecoin "zapping" and Synthetix native collateral unwinding by integrating flash loans from Aave and Uniswap v3 swaps.

### What is a **Zap**?
> ONLY USDC is supported

USDC <--(spot market)--> sUSDC <--(spot market)--> USDx

### What is **Collateral Unwinding**?

#### Flashloan Utility Flow

1. **Request Flash Loans (Aave):** Borrow USDC to access liquidity without posting collateral.
2. **Zap into USDx (Synthetix Spot Market):** Use the borrowed funds to zap into USDx.
3. **Burn USDx & Repay Debt (Synthetix Core):** Repay Synthetix debt by burning USDx.
4. **Withdraw and Unwrap Collateral (Synthetix Spot Market):** Withdraw margin (e.g., sETH) and convert it back to underlying assets (e.g., WETH).
5. **Swap (Uniswap):** Exchange collateral assets (like WETH) for USDC to repay the flash loan.
6. **Flash Loan Repayment (Aave):** The USDC loan, including the premium, is repaid to Aave.
7. **Send Remaining Collateral (Synthetix):** Any surplus collateral is returned to the user.

## Key Features

- Zap via Synthetix
- Wrap & Unwrap Collateral via Synthetix
- Buy & Sell via Synthetix
- Unwind Collateral via Synthetix, Aave, and Uniswap
- Burn Debt via Synthetix
- Withdraw Perp Collateral via Synthetix
- Swap via Uniswap

## Build and Test

### Build and Run

1. **Build the project**  
   ```bash
   forge build
   ```

2. **Run tests**  
   ```bash
   forge test
   ```

## Deployment

- See the `deployments/` folder for Arbitrum and Base deployments.

## Audits

- See the `audits/` folder for Audit reports.
