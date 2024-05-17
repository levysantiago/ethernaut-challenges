// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import {Reentrance} from "../src/Reentrance.sol";
import {ReentranceAttacker} from "../src/ReentranceAttacker.sol";
import {Test} from "forge-std/Test.sol";

contract ReentranceAttackerTest is Test {
  Reentrance reentranceContract;
  ReentranceAttacker reentranceAtacker;
  address attacker;
  
  function setUp() public{
    vm.deal(address(this), 1 ether);
    vm.deal(attacker, 1 ether);
    
    // Donating with the test contract
    reentranceContract = new Reentrance();
    reentranceContract.donate{value: 1 ether}(address(this));

    vm.prank(attacker);
    reentranceAtacker = new ReentranceAttacker(address(reentranceContract));
  }

  function testShouldStealAllBalance() public{
    assertEq(address(reentranceContract).balance, 1 ether);

    vm.prank(attacker);
    reentranceAtacker.attack{value: 0.2 ether}();

    assertEq(address(reentranceContract).balance, 0 ether);
  }
}