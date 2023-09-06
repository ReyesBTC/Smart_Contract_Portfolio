// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/// @title SimpleMathTest
/// @author Christian Reyes 
/// @notice This contract tests the functionalities of the SimpleMath contract.
/// @dev Using the Test contract from forge-std as the testing framework.

// Importing the Test contract from forge-std and the SimpleMath contract from the local src directory.
import "forge-std/Test.sol";
import {SimpleMath} from "../src/SimpleMath.sol";

contract SimpleMathTest is Test {
    /// @notice The SimpleMath contract instance that will be tested.
    /// @dev A new SimpleMath contract is deployed in the setUp function before each test.
    SimpleMath public simpleMath;

    /// @notice A test variable for potential use in tests.
    /// @dev Currently not used in any of the test functions.
    uint256 public testVariable;

    /// @notice Sets up the testing environment before each test.
    /// @dev Deploys a new SimpleMath contract with an initial value of 10.
    function setUp() public {
        simpleMath = new SimpleMath(10);
    }

    /// @notice Test case for the doubleNumber function in the SimpleMath contract.
    /// @dev Calls the doubleNumber function with 10 and then asserts that the returned value is 20.
    function test_doubleNumber() public {
        assertEq(simpleMath.doubleNumber(10), 20);
    }

    /// @notice Test case for the addNumbers function in the SimpleMath contract.
    /// @dev Calls the addNumbers function with 10 and 10, then asserts that the returned value is 20.
    function addNumbers() public {
        assertEq(simpleMath.addNumbers(10, 10), 20);
    }

    /// @notice Test case expected to fail for the addNumbers function in the SimpleMath contract.
    /// @dev Calls the addNumbers function with 5 and 5, then asserts that the returned value is 20 (which should fail).
    function testFail_addNumbers() public {
        assertEq(simpleMath.addNumbers(5, 5), 20);
    }

    /// @notice Test case expected to fail for the doubleNumber function in the SimpleMath contract.
    /// @dev Calls the doubleNumber function with 5, then asserts that the returned value is 20 (which should fail).
    function testFail_doubleNumber() public {
        assertEq(simpleMath.doubleNumber(5), 20);
    }
}
