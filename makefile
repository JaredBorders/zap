deploy_base:
	source .env && forge script --chain base script/Deploy.s.sol:DeployBase --rpc-url $$BASE_RPC --broadcast --verify -vvvv

coverage:
	forge coverage --report lcov --ir-minimum

snapshot:
	forge snapshot
