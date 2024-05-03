# Level 4: Telephone

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446)

**Description**:

While this example may be simple, confusing `tx.origin` with `msg.sender` can lead to phishing-style attacks, such as [this](https://blog.ethereum.org/2016/06/24/security-alert-smart-contract-wallets-created-in-frontier-are-vulnerable-to-phishing-attacks).

An example of a possible attack is outlined below.

1. Use `tx.origin` to determine whose tokens to transfer, e.g.

```javascript
function transfer(address _to, uint _value) {
  tokens[tx.origin] -= _value;
  tokens[_to] += _value;
}
```

2. Attacker gets victim to send funds to a malicious contract that calls the transfer function of the token contract, e.g.

```javascript
function () payable {
  token.transfer(attackerAddress, 10000);
}
```

In this scenario, `tx.origin` will be the victim's address (while `msg.sender` will be the malicious contract's address), resulting in the funds being transferred from the victim to the attacker.

**Instance used**: [0x520d85a25A9b14Eeb3Fa3d1eceE88B98882eB8b5](https://sepolia.etherscan.io/address/0x520d85a25A9b14Eeb3Fa3d1eceE88B98882eB8b5)

**Attacker Contract**: [0x82E69EBbD5f4D3822a252060932fe6661D4A6b4b](https://sepolia.etherscan.io/address/0x82E69EBbD5f4D3822a252060932fe6661D4A6b4b)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x583b596d2862582d55eb43be989d56f4493a168fdcb0370e77d9cc4b9f33e30d)

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