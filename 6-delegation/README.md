# Level 6: Delegation

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x73379d8B82Fda494ee59555f333DF7D44483fD58)

**Description**:

Usage of delegatecall is particularly risky and has been used as an attack vector on multiple historic hacks. With it, your contract is practically saying "here, -other contract- or -other library-, do whatever you want with my state". Delegates have complete access to your contract's state. The delegatecall function is a powerful feature, but a dangerous one, and must be used with extreme care.

Please refer to the [The Parity Wallet Hack Explained](https://blog.openzeppelin.com/on-the-parity-wallet-multisig-hack-405a8c12e8f7) article for an accurate explanation of how this idea was used to steal 30M USD.

**Instance used**: [0x0f43E30428e74A96488110F493A8FD3C903a6652](https://sepolia.etherscan.io/address/0x0f43E30428e74A96488110F493A8FD3C903a6652)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0xd912b53f931413feffe385f6da4724bc7b86a89d2c3c13c4998a4f6387a3b22f)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0xcd583eacd2fb35d4c067497ca4c830d73e2e062b48f439d2196284b79c08e081)

# Getting started

## Build

```bash
make build
```

## Test

```bash
make test
```

## Attack (mainnet)

```bash
make attack
```

## Submit level (mainnet)

```bash
make submit
```

## Check if you completed the level (mainnet)

`true` - You completed the level
`false` - You didn't complete the level

```bash
make check
```