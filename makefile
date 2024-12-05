deploy_base:
	source .env && forge script --chain base script/Deploy.s.sol:DeployBase --rpc-url $$BASE_RPC --broadcast --verify -vvvv

deploy_arbitrum:
	source .env && forge script --chain arbitrum script/Deploy.s.sol:DeployArbitrum --rpc-url $$ARBITRUM_RPC --broadcast --verify -vvvv

coverage:
	forge coverage --report lcov --ir-minimum

snapshot:
	forge snapshot
