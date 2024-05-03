# Level 0: Hello Ethernaut

**Level Page**: [See on Ethernaut](https://ethernaut.openzeppelin.com/level/0x7E0f53981657345B31C59aC44e9c21631Ce710c7)

**Description**:

This level walks you through the very basics of how to play the game. See the [Ethernaut level 1 webpage](https://ethernaut.openzeppelin.com/level/0x7E0f53981657345B31C59aC44e9c21631Ce710c7) to learn the basics of the game.

**Code**:

The smart contract to be exploited:

<details>
<summary>See Code</summary>

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Instance {
    string public password;
    uint8 public infoNum = 42;
    string public theMethodName = "The method name is method7123949.";
    bool private cleared = false;

    // constructor
    constructor(string memory _password) {
        password = _password;
    }

    function info() public pure returns (string memory) {
        return "You will find what you need in info1().";
    }

    function info1() public pure returns (string memory) {
        return 'Try info2(), but with "hello" as a parameter.';
    }

    function info2(string memory param) public pure returns (string memory) {
        if (keccak256(abi.encodePacked(param)) == keccak256(abi.encodePacked("hello"))) {
            return "The property infoNum holds the number of the next info method to call.";
        }
        return "Wrong parameter.";
    }

    function info42() public pure returns (string memory) {
        return "theMethodName is the name of the next method.";
    }

    function method7123949() public pure returns (string memory) {
        return "If you know the password, submit it to authenticate().";
    }

    function authenticate(string memory passkey) public {
        if (keccak256(abi.encodePacked(passkey)) == keccak256(abi.encodePacked(password))) {
            cleared = true;
        }
    }

    function getCleared() public view returns (bool) {
        return cleared;
    }
}
```

</details>

# Attack

**Description**: This is like the Ethernaut "Hello World", so there is no much to say about vulnerabilities here. We just need to get the password through the function `Instance::password()(string)` and execute the function `Instance::authenticate(string memory)` passing the password value to it.

Code from `HelloEthernautAttack.s.sol`:

```javascript
  string memory pass = helloEthernaut.password();
  helloEthernaut.authenticate(pass);
```

**Instance used**: [0xBd71Ab79388A8C299953dc13A432b93D564DACad](https://sepolia.etherscan.io/address/0xBd71Ab79388A8C299953dc13A432b93D564DACad)

**Attack Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0xc7503b04cc10028c8f0ef67c6c3dc625fa2d1651a57ea49c2469b3d63e55175e)

**Level Completed Transaction**: [see on etherscan](https://sepolia.etherscan.io/tx/0x70b2fb3510848c54e54413687fd8be8962a7503fd74140c0a9ac8f452594429b)


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