// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {Instance as HelloEthernaut} from "../../src/hello-ethernaut/HelloEthernaut.sol";

contract DeployHelloEthernaut is Script{
  function run() public{
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);
    
    new HelloEthernaut("ethernaut0");
    
    vm.stopBroadcast();
  }
}