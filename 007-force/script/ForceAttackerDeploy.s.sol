// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Force} from "../src/Force.sol";
import {ForceAttacker} from "../src/ForceAttacker.sol";

contract ForceAttackerDeploy is Script {
  function run() public{
    address forceAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attackerPK);

    new ForceAttacker(forceAddress);

    vm.stopBroadcast();
  }
}