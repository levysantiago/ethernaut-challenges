[![test](https://github.com/levysantiago/ethernaut-challenges/actions/workflows/test.yml/badge.svg)](https://github.com/levysantiago/ethernaut-challenges/actions/workflows/test.yml)

# Ethernaut Challenges on Foundry

**Ethernaut**
[Ethernaut](https://ethernaut.openzeppelin.com/) is a web platform created by [OpenZeppelin](https://www.openzeppelin.com/). The Ethernaut holds many challenges where we can explore smart contracts vulnerabilities by trying to exploit these contracts. Of course, these contracts where developed to be "hacked", so it is expected that they have some bugs and vulnerabilities and, therefore, YOU SHOULD NOT USE THEM IN PRODUCTION!

**This repo**
I started to solve the Ethernaut levels and to save the solutions in this repo. You can solve the levels using the Ethernaut website console and sometimes the [RemixIDE](https://remix.ethereum.org), but I decided to solve them using [Foundry](https://book.getfoundry.sh/) and share my solutions with you. Here I also explain how I managed to attack the contract and how would be the right way to avoid the vulnerability.

## Getting Started

Before you continue, if you didn't solve any Ethernaut challenges, `I FULLY RECOMMEND YOU TRY TO SOLVE THE CHALLENGES BY YOURSELF BEFORE GETTING SOLUTION SPOILERS HERE`! Try starting from the [level 1](https://ethernaut.openzeppelin.com/level/0x7E0f53981657345B31C59aC44e9c21631Ce710c7).

Each Ethernaut level in this repo is a Foundry project. If you want to know how to execute each one of them, you can just access the level folder. Each level folder has it's own `README.md`.

Here is the status of the levels solutions I already completed and uploaded here.

| level | Name             | Completed |
| ----- | ---------------- | --------- |
| 0     | Hello Ethernaut  | ✅         |
| 1     | Fallback         | ✅         |
| 2     | Fallout          | ✅         |
| 3     | CoinFlip         | ✅         |
| 4     | Telephone        | ✅         |
| 5     | Token            | ✅         |
| 6     | Delegation       | ✅         |
| 7     | Force            | ⌛️         |
| 8     | Vault            | ⌛️         |
| 9     | King             | ⌛️         |
| 10    | Re-entrancy      | ⌛️         |
| 11    | Elevator         | ⌛️         |
| 12    | Privacy          | ⌛️         |
| 13    | Gatekeeper One   | ⌛️         |
| 14    | Gatekeeper Two   | ⌛️         |
| 15    | Naught Coin      | ⌛️         |
| 16    | Preservation     | ⌛️         |
| 17    | Recovery         | ⌛️         |
| 18    | MagicNumber      | ⌛️         |
| 19    | Allen Codex      | ⌛️         |
| 20    | Denial           | ⌛️         |
| 21    | Shop             | ⌛️         |
| 22    | Dex              | ⌛️         |
| 23    | Dex Two          | ⌛️         |
| 24    | Puzzle Wallet    | ⌛️         |
| 25    | Motorbike        | ⌛️         |
| 26    | DoubleEntryPoint | ⌛️         |
| 27    | Good Samaritan   | ⌛️         |
| 28    | Gatekeeper Tree  | ⌛️         |
| 29    | Switch           | ⌛️         |
| 30    | HigherOrder      | ⌛️         |
| 31    | Stake            | ⌛️         |

### Install Foundry

Please, follow the [Foundry Installation guide](https://book.getfoundry.sh/getting-started/installation) to install Foundry in your machine.

### Environmental variables

Each individual level folder has a `.env` file. To execute the commands you should fill these variables first. Consult the `.env.example` in each sub-project folder. Some of them are:

```text
PRIVATE_KEY=
SEPOLIA_RPC_URL=
ETHERNAUT_CONTRACT_INSTANCE=0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6
VICTIM_CONTRACT_INSTANCE=
ATTACKER_CONTRACT=
```

- `PRIVATE_KEY`: The private key of the address that will execute the transactions in this project. It must be the same wallet that created the contract instance in the Ethernaut website.
- `SEPOLIA_RPC_URL`: The sepolia RPC node URL. See the [list of nodes available](https://chainlist.org/chain/11155111).
- `ETHERNAUT_CONTRACT_INSTANCE`: The Ethernaut contract address. 
- `VICTIM_CONTRACT_INSTANCE`: The contract address of the level instance you deployed on the sepolia testnet.
- `ATTACKER_CONTRACT`: In some levels you will need to deploy an attacker contract first, and then perform the attack to the level instance. This variable represents the attacker contract address.

### Risk Classification

Inside the projects `README.md` you may find the risk classifications as `[H-1]`, `[M-1]`, the number represents the sequence of findings of the same risk type, and the risk classification is based on:

|            |        | Impact |        |     |
| ---------- | ------ | ------ | ------ | --- |
|            |        | High   | Medium | Low |
|            | High   | H      | H/M    | M   |
| Likelihood | Medium | H/M    | M      | M/L |
|            | Low    | M      | M/L    | L   |

### Fixing the vulnerabilities

Each level has a `README.md` with all the information about the level, about the vulnerability found, about the attack I made to the instances I deployed, and finally the recommended mitigation to improve each level protocol.

It's important to highlight that in this repo I don't explore other possible vulnerabilities in these contracts because this is just a game, many contracts there where created to exploit one specific vulnerability without any hole project context, so it doesn't make much sense trying to find more vulnerabilities if we don't know the context where the code is placed (mainly because it's just a game 😊).

# Links

- [Ethernaut](https://ethernaut.openzeppelin.com/)
- [OpenZeppelin](https://www.openzeppelin.com/)
- [Sepolia Scan](https://sepolia.etherscan.io/)
- [Get Sepolia Faucet](https://www.alchemy.com/faucets/ethereum-sepolia)
- [Foundry Book](https://book.getfoundry.sh/)