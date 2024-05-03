-include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

install :; forge install foundry-rs/forge-std --no-commit

test :; forge test 

build :; forge build

attack:; forge script script/FalloutAttack.s.sol:FalloutAttack --fork-url sepolia --broadcast

check:; source .env && cast call $$ETHERNAUT_CONTRACT_INSTANCE "emittedInstances(address)(address, address, bool)" $$VICTIM_CONTRACT_INSTANCE --rpc-url sepolia