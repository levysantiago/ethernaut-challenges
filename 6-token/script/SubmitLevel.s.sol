// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Script} from "forge-std/Script.sol";
import {IEthernaut} from "../src/IEthernaut.sol";

contract SubmitLevel is Script{
  function run() public{
    address ethernautAddress = vm.envAddress("ETHERNAUT_CONTRACT_INSTANCE");
    address victimAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    
    IEthernaut ethernaut = IEthernaut(ethernautAddress);
    
    // Instantiating attacker contract
    vm.startBroadcast(attacker);

    // Submitting phase
    ethernaut.submitLevelInstance(payable(victimAddress));
    
    vm.stopBroadcast();
  }
}