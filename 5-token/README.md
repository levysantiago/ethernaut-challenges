# Level 5: Token

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x478f3476358Eb166Cb7adE4666d04fbdDB56C407)

**Description**:

Overflows are very common in solidity and must be checked for with control statements such as:

```javascript
if(a + c > a) {
  a = a + c;
}
```

An easier alternative is to use OpenZeppelin's SafeMath library that automatically checks for overflows in all the mathematical operators. The resulting code looks like this:

```javascript
a = a.add(c);
```

If there is an overflow, the code will revert.

**Instance used**: [0x3B73aDaaFF46681F725bfb23A7414554458C6D0E](https://sepolia.etherscan.io/address/0x3B73aDaaFF46681F725bfb23A7414554458C6D0E)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x32db0a045a9d64c04301751887f085ef97d6bb4316fbc05b6017630f1906ded3)

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