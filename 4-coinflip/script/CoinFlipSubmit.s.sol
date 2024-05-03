// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {CoinFlip} from "../src/CoinFlip.sol";
import {CoinFlipAttacker} from "../src/CoinFlipAttacker.sol";
import {IEthernaut} from "../src/IEthernaut.sol";

contract CoinFlipSubmit is Script{
  function run() public{
    address ethernautAddress = vm.envAddress("ETHERNAUT_CONTRACT_INSTANCE");
    address coinFlipAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    
    IEthernaut ethernaut = IEthernaut(ethernautAddress);
    
    // Instantiating attacker contract
    vm.startBroadcast(attacker);

    // Submitting phase
    ethernaut.submitLevelInstance(payable(coinFlipAddress));
    
    vm.stopBroadcast();
  }
}