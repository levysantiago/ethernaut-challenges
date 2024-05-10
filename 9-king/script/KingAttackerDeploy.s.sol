// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {KingAttacker} from "../src/KingAttacker.sol";

contract KingAttackerDeploy is Script{
  function run() public{
    address kingAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    vm.broadcast(attackerPK);
    new KingAttacker(kingAddress);
  }
}