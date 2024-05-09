# Level 8: Vault

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0xB7257D8Ba61BD1b3Fb7249DCd9330a023a5F3670)

**Description**:

Unlock the vault to pass the level!

`Text after completing the level`:

It's important to remember that marking a variable as private only prevents other contracts from accessing it. State variables marked as private and local variables are still publicly accessible.

To ensure that data is private, it needs to be encrypted before being put onto the blockchain. In this scenario, the decryption key should never be sent on-chain, as it will then be visible to anyone who looks for it. [zk-SNARKs](https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell) provide a way to determine whether someone possesses a secret parameter, without ever having to reveal the parameter.

**Code**

Code to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}
```

</details>

# Findings

## [H-1] Relying on private state variables with saving sensitive data allows anyone to read this data and use it maliciously since all data on smart contract is public

**Description**: Even if the visibility of `Vault::password` variable is `private`, this doesn't mean that no one can read it, only that other contracts can't access it. As said in [Solidity docs](https://docs.soliditylang.org/en/latest/security-considerations.html#private-information-and-randomness), all data on smart contract is publicly visible. So in this case, we can read the `Vault::password` value and use it to attack the contract executing the `Vault::unlock`.

**Impact:** Depending on the project context, the impact can vary. We do use `private` keywords to keep some functions and variables private from other contracts, but never save sensitive data to it. Considering that the only purpose of this contract is to lock and unlock with a password, then this bug can allow anyone break the whole protocol by unlocking the contract anytime.

**Proof of Code**: This test inside `VaultAttack.t.sol` proofs that we can do that:

```javascript
function testShouldUnlockVault() public{
  vm.deal(attacker, 1 ether);
  
  assertTrue(vault.locked());

  bytes32 password = vm.load(address(vault), bytes32(uint256(1)));
  
  vm.prank(attacker);
  vault.unlock(password);

  assertFalse(vault.locked());
}
```

**Recommended mitigation**: It is fully recommended to not save any sensitive data to smart contracts like that, if you really need to do that, you should encrypt the data first using an external and reliable source, and then save the encrypted version to the blockchain. But in this case, even using an encrypted password someone could read this value and use the encrypted password to break the protocol anyway. So one recommendation is to use the [Ownable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/README.adoc) strategy or any other access control pattern, so you could only allow specific addresses to unlock the contract.

For example, using OpenZeppelin ownership pattern:

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault is Ownable {
    bool public locked;

    constructor() {
      locked = true;
    }

    function unlock(bytes32 _password) public onlyOwner{
      locked = false;
    }
}
```

# Attack

**Description**: 

```javascript

```

**Instance used**: [0xfDfeDD105523243Cd93f338D5C267142CE28d110](https://sepolia.etherscan.io/address/0xfDfeDD105523243Cd93f338D5C267142CE28d110)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x2ef843230a624ac43b77fb507ef95fe72883fb29deef1f60073218cf907ef64c)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x9a03a94d39a1cf49eb61e5d5a6d40123900fa93420f8a1c70ee69a5d6b405c64)

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