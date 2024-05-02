// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Ethernaut{
  function submitLevelInstance(address payable _instance) external;
  function emittedInstances(address) external view returns (address, address, bool);
}