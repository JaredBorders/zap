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

## Contracts

> `tree src/`

```
src/
├── Zap.sol
├── ZapErrors.sol
├── ZapEvents.sol
└── interfaces
    ├── IERC20.sol
    └── ISpotMarketProxy.sol
```

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