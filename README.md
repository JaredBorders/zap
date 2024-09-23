# Zap

[![Github Actions][gha-badge]][gha] 
[![Foundry][foundry-badge]][foundry] 
[![License: GPL-3.0][license-badge]][license]

[gha]: https://github.com/JaredBorders/Zap/actions
[gha-badge]: https://github.com/JaredBorders/Zap/actions/workflows/test.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/license/GPL-3.0/
[license-badge]: https://img.shields.io/badge/GitHub-GPL--3.0-informational

## Aave Flashloans

Execution Flow
For developers, a helpful mental model to consider when developing your solution:
Your contract calls the Pool contract, requesting a Flash Loan of a certain amount(s) of reserve(s) using flashLoanSimple() or flashLoan().
After some sanity checks, the Pool transfers the requested amounts of the reserves to your contract, then calls executeOperation() on receiver contract .
Your contract, now holding the flash loaned amount(s), executes any arbitrary operation in its code.
If you are performing a flashLoanSimple, then when your code has finished, you approve Pool for flash loaned amount + fee.
If you are performing flashLoan, then for all the reserves either depending on interestRateMode passed for the asset, either the Pool must be approved for flash loaned amount + fee or must or sufficient collateral or credit delegation should be available to open debt position.
If the amount owing is not available (due to a lack of balance or approval or insufficient collateral for debt), then the transaction is reverted.
All of the above happens in 1 transaction (hence in a single ethereum block).

The flash loan fee is initialized at deployment to 0.05% and can be updated via Governance Vote. Use FLASHLOAN_PREMIUM_TOTAL to get current value.
Flashloan fee can be shared by the LPs (liquidity providers) and the protocol treasury. The FLASHLOAN_PREMIUM_TOTAL represents the total fee paid by the borrowers of which:
Fee to LP: FLASHLOAN_PREMIUM_TOTAL - FLASHLOAN_PREMIUM_TO_PROTOCOL
Fee to Protocol: FLASHLOAN_PREMIUM_TO_PROTOCOL

The pool.sol contract is the main user facing contract of the protocol. It exposes the liquidity management methods that can be invoked using either Solidity or Web3 libraries.

flashLoanSimple
function flashLoanSimple( address receiverAddress, address asset, uint256 amount, bytes calldata params, uint16 referralCode)
Allows users to access liquidity of one reserve or one transaction as long as the amount taken plus fee is returned.

## Tests

1. Follow the [Foundry guide to working on an existing project](https://book.getfoundry.sh/projects/working-on-an-existing-project.html)

2. Build project

```
npm run compile
```

3. Execute tests (requires rpc url(s) to be set in `.env`)

```
npm run test
```

4. Run specific test

```
forge test --fork-url $(grep BASE_RPC_URL .env | cut -d '=' -f2) --match-test TEST_NAME -vvv
```

## Deployment Addresses

> See `deployments/` folder

1. Optimism deployments found in `deployments/Optimism.json`
2. Optimism Goerli deployments found in `deployments/OptimismGoerli.json`
3. Base deployments found in `deployments/Base.json`
4. Base Goerli deployments found in `deployments/BaseGoerli.json`

## Audits

> See `audits/` folder

1. Internal audits found in `audits/internal/`
2. External audits found in `audits/external/`