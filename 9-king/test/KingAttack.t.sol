// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {King} from "../src/King.sol";
import {KingAttacker} from "../src/KingAttacker.sol";

contract KingAttack is Test {
  King king;
  KingAttacker kingAttacker;
  address owner;
  address attacker;

  function setUp() public{
    owner = makeAddr("owner");
    attacker = makeAddr("attacker");
    vm.deal(owner, 1 ether);
    vm.deal(attacker, 1 ether);

    vm.prank(owner);
    king = new King{value: 1 wei}();
    
    vm.prank(attacker);
    kingAttacker = new KingAttacker(address(king));
  }

  function testShouldBlockNextInvestmentst() public{
    vm.prank(attacker);
    kingAttacker.attack{value: 2 wei}();

    assertEq(king._king(), address(kingAttacker));

    vm.expectRevert();
    vm.prank(owner);
    (bool success, ) = address(king).call{value: 3 wei}("");

    assertTrue(success);
    assertEq(king._king(), address(kingAttacker));
  }
}