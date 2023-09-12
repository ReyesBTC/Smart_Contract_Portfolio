// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title KatyaLovesChristianTest
/// @author Christian Reyes
/// @notice This contract tests the functionalities of the KatyaLovesChristian contract.
/// @dev Make sure your gs'sflove you too. Using the Test contract from forge-std as the testing framework.

// Importing the Test contract from forge-std and the KatyaLovesChristian contract from the local src directory.
import "forge-std/Test.sol";
import { KatyaLovesChristian } from "../src/KatyaLovesChristian.sol";

contract KatyaLovesChristianTest is Test {
  /// @notice The KatyaLovesChristian contract instance that will be tested.
  /// @dev A new KatyaLovesChristian contract is deployed in the setUp function before each test.
  KatyaLovesChristian public katyaLovesChristian;

  /// @notice Sets up the testing environment before each test.
  /// @dev Deploys a new KatyaLovesChristian contract.
  function setUp() public {
    katyaLovesChristian = new KatyaLovesChristian();
  }

  /// @notice Test case for the doesKatyaLoveChristian function with true as input.
  /// @dev Calls the doesKatyaLoveChristian function with true and then asserts that the returned string is "Yes, Katya loves Christian".
  function test_doesKatyaLovesChristianTRUE() public {
    assertEq(
      keccak256(abi.encodePacked(katyaLovesChristian.doesKatyaLoveChristian(true))),
      keccak256(abi.encodePacked("Yes, Katya loves Christian"))
    );
  }

  /// @notice Test case for the doesKatyaLoveChristian function with false as input.
  /// @dev Calls the doesKatyaLoveChristian function with false and then asserts that the returned string is "Yes, Katya loves Christian but her typing is a bit retarded at the moment".
  function test_doesKatyaLovesChristianFALSE() public {
    assertEq(
      keccak256(abi.encodePacked(katyaLovesChristian.doesKatyaLoveChristian(false))),
      keccak256(abi.encodePacked("Yes, Katya loves Christian but her typing is a bit retarded at the moment"))
    );
  }

  /// @notice Test case for the katyaLovesChristian function.
  /// @dev Calls the katyaLovesChristian function and then asserts that the returned value is true.
  function test_katyaLovesChristian() public {
    assertEq(katyaLovesChristian.katyaLovesChristian(), true);
  }
}
