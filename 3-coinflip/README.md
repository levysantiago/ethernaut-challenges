# Level 3: CoinFlip

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF)

**Description**:

Generating random numbers in solidity can be tricky. There currently isn't a native way to generate them, and everything you use in smart contracts is publicly visible, including the local variables and state variables marked as private. Miners also have control over things like blockhashes, timestamps, and whether to include certain transactions - which allows them to bias these values in their favor.

To get cryptographically proven random numbers, you can use [Chainlink VRF](https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number), which uses an oracle, the LINK token, and an on-chain contract to verify that the number is truly random.

Some other options include using Bitcoin block headers (verified through [BTC Relay](http://btcrelay.org/)), [RANDAO](https://github.com/randao/randao), or [Oraclize](https://medium.com/coinmonks/simple-oraclize-example-with-solidity-68b6811902da)).

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