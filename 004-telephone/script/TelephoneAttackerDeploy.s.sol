// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {TelephoneAttacker} from "../src/TelephoneAttacker.sol";

contract TelephoneAttackerDeploy is Script{
  function run() public{
    address telephoneAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attackerPK);
    
    new TelephoneAttacker(telephoneAddress);

    vm.stopBroadcast();
  }
}