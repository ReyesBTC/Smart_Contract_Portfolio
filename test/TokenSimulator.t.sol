// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Token Simulator Test Contract
/// @author Christian Reyes
/// @notice This contract tests the functionalities of the TokenSimulator contract.
/// @dev Using the Test contract from forge-std as the testing framework.

// Importing the TokenSimulator contract from the local src directory and the Test contract from forge-std.
import {TokenSimulator} from "../src/TokenSimulator.sol";
import "forge-std/Test.sol";

contract TokenSimulatorTest is Test {
    /// @notice The TokenSimulator contract instance that will be tested.
    /// @dev A new TokenSimulator contract is deployed in the setUp function before each test with an initial supply of 10000.
    TokenSimulator public tokenSimulator;

    /// @notice A test variable for potential use in tests.
    /// @dev Currently not used in any of the test functions.
    uint256 public testVariable;

    /// @notice Sets up the testing environment before each test.
    /// @dev Deploys a new TokenSimulator contract with an initial supply of 10000.
    function setUp() public {
        tokenSimulator = new TokenSimulator(10000);
    }

    /// @notice Test case for the approve function in the TokenSimulator contract.
    /// @dev Calls the approve function with the test contract's address and an allowance of 100, then asserts that the returned value is true.
    function test_approve() public {
        assertEq(tokenSimulator.approve(address(this), 100), true);
    }
}
