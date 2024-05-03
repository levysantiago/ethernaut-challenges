// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {CoinFlip} from "../src/CoinFlip.sol";
import {CoinFlipAttacker} from "../src/CoinFlipAttacker.sol";
import {IEthernaut} from "../src/IEthernaut.sol";

contract CoinFlipAttackerDeploy is Script{
  function run() public{
    address coinFlipAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    
    vm.broadcast(attacker);
    
    // Instantiating attacker contract
    new CoinFlipAttacker(coinFlipAddress);
  }
}