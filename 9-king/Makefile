-include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

install :; forge install foundry-rs/forge-std --no-commit

test :; forge test 

build :; forge build

prize:; source .env && cast call $$VICTIM_CONTRACT_INSTANCE "prize()(uint256)" --rpc-url sepolia

deploy:; forge script script/KingAttackerDeploy.s.sol:KingAttackerDeploy --fork-url sepolia --broadcast --skip-simulation

attack:; forge script script/KingAttack.s.sol:KingAttack --fork-url sepolia --broadcast --skip-simulation

submit:; forge script script/SubmitLevel.s.sol:SubmitLevel --fork-url sepolia --broadcast --skip-simulation

check:; source .env && cast call $$ETHERNAUT_CONTRACT_INSTANCE "emittedInstances(address)(address, address, bool)" $$VICTIM_CONTRACT_INSTANCE --rpc-url sepolia