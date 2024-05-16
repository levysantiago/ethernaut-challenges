// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Force} from "../src/Force.sol";
import {ForceAttacker} from "../src/ForceAttacker.sol";

contract ForceAttackerTest is Test{
  Force force;
  ForceAttacker forceAttacker;
  address attacker;
  uint256 ATTACKER_BALANCE = 1 wei;

  function setUp() public{
    force = new Force();
    
    attacker = makeAddr("attacker");

    vm.deal(attacker, ATTACKER_BALANCE);
    vm.prank(attacker);
    forceAttacker = new ForceAttacker(address(force));
  }

  function testShouldForceSendingTokenToContract() public{
    assertEq(address(force).balance, 0);
    
    vm.prank(attacker);
    forceAttacker.attack{value: ATTACKER_BALANCE}();

    assertEq(address(force).balance, ATTACKER_BALANCE);
  }
}