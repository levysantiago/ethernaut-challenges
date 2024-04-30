// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {Ethernaut} from "../src/Ethernaut.sol";

contract EthernautDeploy is Script{
  function run() public{
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(deployerPrivateKey);
    
    new Ethernaut();
    
    vm.stopBroadcast();
  }
}