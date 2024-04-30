// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";
import {Ethernaut} from "../../src/Ethernaut.sol";
import {FallbackAttacker} from "../../src/2-fallback/FallbackAttacker.sol";
import {Fallback} from "../../src/2-fallback/Fallback.sol";

contract FallbackAttackerTest is Test{
  Ethernaut ethernaut;
  Fallback fallbackContract;
  FallbackAttacker sut;
  address owner;
  uint256 INITIAL_BALANCE = 1e18;
  
  function setUp() public {
    fallbackContract = new Fallback();
    ethernaut = new Ethernaut();
    owner = vm.addr(3);
    vm.deal(address(owner), INITIAL_BALANCE);
    vm.prank(owner);
    sut = new FallbackAttacker(address(fallbackContract));
  }

  function testShouldStealContractBalance() public{
    address contribuitor1 = vm.addr(1);
    address contribuitor2 = vm.addr(2);
    vm.deal(contribuitor1, 1e18);
    vm.deal(contribuitor2, 1e18);

    vm.prank(contribuitor1);
    fallbackContract.contribute{value: 100 wei}();

    vm.prank(contribuitor2);
    fallbackContract.contribute{value: 100 wei}();

    // attack
    vm.startPrank(owner);

    sut.attack{value: 2}();

    vm.stopPrank();

    assertEq(fallbackContract.contributions(address(sut)), 1);
    assertEq(fallbackContract.owner(), address(sut));
    assertEq(address(owner).balance, INITIAL_BALANCE + 200);
  }
}