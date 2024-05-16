// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {TelephoneAttacker} from "../src/TelephoneAttacker.sol";

contract TelephoneAttack is Script{
  function run() public{
    address telephoneAttackerAddress = vm.envAddress("ATTACKER_CONTRACT");
    TelephoneAttacker telephoneAttacker = TelephoneAttacker(telephoneAttackerAddress);

    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attackerPK);

    // Attack
    telephoneAttacker.attack();

    vm.stopBroadcast();
  }
}