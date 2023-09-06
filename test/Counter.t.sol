// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Importing the Test contract from forge-std and the Counter contract from the local src directory.
import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

/// @title Counter Test Contract
/// @author Christian Reyes 
/// @notice This contract tests the functionalities of the Counter contract.
/// @dev The contract uses the Test contract from forge-std as the testing framework.

contract CounterTest is Test {
    /// @notice The Counter contract instance that will be tested.
    /// @dev A new Counter contract is deployed in the setUp function before each test.
    Counter public counter;

    /// @notice Sets up the testing environment before each test.
    /// @dev Deploys a new Counter contract and sets its initial number to 0.
    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    /// @notice Test case for the increment function in the Counter contract.
    /// @dev Calls the increment function and then asserts that the number has increased by 1.
    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    /// @notice Fuzz test case for the setNumber function in the Counter contract.
    /// @dev Sets a random number x and then asserts that the number is set correctly.
    /// @param x The random number to be set in the Counter contract.
    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
