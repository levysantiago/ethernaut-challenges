-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

install :; forge install foundry-rs/forge-std

test :; forge test 

1-hello-ethernaut:; forge script script/1-hello-ethernaut/HelloEthernaut.s.sol:HelloEthernaut --fork-url sepolia --broadcast

2-fallback:; forge script script/2-fallback/FallbackAttack.s.sol:FallbackAttack --fork-url sepolia --broadcast

check:; source .env && cast call $$ETHERNAUT_CONTRACT_INSTANCE "emittedInstances(address)(address, address, bool)" $$VICTIM_CONTRACT_INSTANCE --rpc-url sepolia