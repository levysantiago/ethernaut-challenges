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
| 7     | Force            | ✅         |
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