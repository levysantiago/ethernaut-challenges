// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";
import {HelloEthernautAttacker} from "../../src/hello-ethernaut/HelloEthernautAttacker.sol";
import {Instance as HelloEthernaut} from "../../src/hello-ethernaut/HelloEthernaut.sol";

contract HelloEthernautAttackerTest is Test{
  HelloEthernautAttacker helloEthernautAttacker;
  HelloEthernaut helloEthernaut;
  
  function setUp() public{
    helloEthernaut = new HelloEthernaut("ethernaut0");
    helloEthernautAttacker = new HelloEthernautAttacker(address(helloEthernaut));
  }

  function testAttack() public{
    helloEthernautAttacker.attack();
    assertEq(helloEthernaut.getCleared(), true);
  }
}