# Level 3: Fallout

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639)

**Description**:

That was silly wasn't it? Real world contracts must be much more secure than this and so must it be much harder to hack them right?

Well... Not quite.

The story of Rubixi is a very well known case in the Ethereum ecosystem. The company changed its name from 'Dynamic Pyramid' to 'Rubixi' but somehow they didn't rename the constructor method of its contract:

```javascript
contract Rubixi {
  address private owner;
  function DynamicPyramid() { owner = msg.sender; }
  function collectAllFees() { owner.transfer(this.balance) }
  ...
```

This allowed the attacker to call the old constructor and claim ownership of the contract, and steal some funds. Yep. Big mistakes can be made in smartcontractland.

**Instance used**: [0x407d461AD2233b6c2Be251185f32E65D23bba754](https://sepolia.etherscan.io/address/0x407d461AD2233b6c2Be251185f32E65D23bba754)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0xa2476837c4d9ebbf1b5f9d197593665466a1b6f987c92c724de0e43665c3ee8d)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x000abfcd41ece4b2b3de24e233d852ba1dc543627a09e6fc7ddb3d8c606a8749)

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