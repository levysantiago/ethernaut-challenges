# Level 10: Re-entrancy

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x2a24869323C0B13Dff24E196Ba072dC790D52479)

**Description**:

The goal of this level is for you to steal all the funds from the contract.

Things that might help:
- Untrusted contracts can execute code where you least expect it.
- Fallback methods
- Throw/revert bubbling
- Sometimes the best way to attack a contract is with another contract.

`Text after completing the level`:

**Code**

Code to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}
```

</details>

# Findings

## [H-1] 

**Description**:

**Impact**:

**Proof of Code**:

**Recommended mitigation**:

# Attack

**Description**: 

**Instance used**: [](https://sepolia.etherscan.io/address/)

**Attacker Contract**: [](https://sepolia.etherscan.io/address/)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/)

# Getting started

## Install lib dependencies

```bash
make install
```

## Build

```bash
make build
```

## Test

```bash
make test
```

## Deploy Attacker Contract (testnet)

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