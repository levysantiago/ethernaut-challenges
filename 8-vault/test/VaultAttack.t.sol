// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

contract VaultAttackTest is Test{
  Vault vault;
  bytes32 EXPECTED_PASSWORD = "0x123456789";
  address attacker;
  
  function setUp() public {
    vault = new Vault(EXPECTED_PASSWORD);
    attacker = makeAddr("attacker");
  }

  function testShouldUnlockVault() public{
    vm.deal(attacker, 1 ether);
    
    assertTrue(vault.locked());

    bytes32 password = vm.load(address(vault), bytes32(uint256(1)));
    
    vm.prank(attacker);
    vault.unlock(password);

    assertFalse(vault.locked());
  }
}