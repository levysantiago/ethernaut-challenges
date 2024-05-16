// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Telephone} from "../src/Telephone.sol";
import {TelephoneAttacker} from "../src/TelephoneAttacker.sol";

contract TelephoneAttack is Test{
  Telephone telephone;
  TelephoneAttacker telephoneAttacker;
  address attacker;

  function setUp() public{
    attacker = makeAddr("attacker");
    vm.deal(attacker, 1 ether);

    telephone = new Telephone();

    vm.prank(attacker);
    telephoneAttacker = new TelephoneAttacker(address(telephone));
  }

  function testShouldDefineInitialOwner() view public{
    assertEq(telephone.owner(), address(this));
  }

  function testShouldClaimOwnership() public{
    
    vm.prank(attacker);
    telephoneAttacker.attack();

    assertEq(telephone.owner(), attacker);
  }
}