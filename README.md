# foundry-scaffold

[![Github Actions][gha-badge]][gha] 
[![Foundry][foundry-badge]][foundry] 
[![License: GPL-3.0][license-badge]][license]

[gha]: https://github.com/Kwenta/foundry-scaffold/actions
[gha-badge]: https://github.com/Kwenta/foundry-scaffold/actions/workflows/test.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/license/GPL-3.0/
[license-badge]: https://img.shields.io/badge/GitHub-GPL--3.0-informational

Template foundry project created by Kwenta

## Getting Started

1. Create an `.env` file using the `.env.example` file as a template
2. Update `package.json` with your project name, description, etc.
3. Update the `README.md` with your project name, description, etc.
4. Add required **Repository Secrets** to your github repository settings
> Navigate to `Settings > Secrets and variables > Actions` and add whatever secrets are required for your project's CI.
5. The current template CI will fail until the following repository secrets are added: `OPTIMISM_GOERLI_RPC_URL` and `ETHERSCAN_API_KEY`. See `.github/workflows/*` for more details.
6. Finally, run `npm run coverage:generate-lcov` to generate a coverage report for your project and commit the results to your remote repository
> This will be used by the CI to determine when changes to your project have caused the coverage to drop below a certain threshold.

## Contracts

> `tree src/`

```
src/
└── Counter.sol
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
    > `OPTIMISM_GOERLI_RPC_URL` can be replaced with `OPTIMISM_RPC_URL` if a mainnet fork is desired

```
forge test --fork-url $(grep OPTIMISM_GOERLI_RPC_URL .env | cut -d '=' -f2) --match-test TEST_NAME -vvv
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