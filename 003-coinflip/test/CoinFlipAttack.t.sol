// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {CoinFlip} from "../src/CoinFlip.sol";
import {CoinFlipAttacker} from "../src/CoinFlipAttacker.sol";

contract CoinFlipAttack is Test{
  CoinFlip coinFlip;
  CoinFlipAttacker coinFlipAttacker;

  function setUp() public{
    coinFlip = new CoinFlip();
    coinFlipAttacker = new CoinFlipAttacker(address(coinFlip));
  }

  function testShouldWinTenTimes() public{
    for(uint i=1;i<=10;i++){
      vm.roll(i);
      coinFlipAttacker.attack();
    }
    
    uint256 consecutiveWins = coinFlip.consecutiveWins();

    assertEq(consecutiveWins, 10);
  }
}