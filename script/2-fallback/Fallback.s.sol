// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {Fallback} from "../../src/2-fallback/Fallback.sol";

contract FallbackDeploy is Script{
  function run() public{
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(deployerPrivateKey);
    
    new Fallback();
    
    vm.stopBroadcast();
  }
}