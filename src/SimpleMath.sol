// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/// @title Simple Math Contract for Testing Purposes
/// @author Christian Reyes 
/// @notice Simple Math Contract for Testing Purposes with Foundry
/// @dev This contract mocks the Chainlink oracle for testing purposes.

contract SimpleMath {
    uint256 public stateVariable;

    constructor(uint256 _initialValue) {
        stateVariable = _initialValue;
    }

    function doubleNumber(uint256 _number) public pure returns (uint256) {
        return _number * 2;
    }

    function addNumbers(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a + _b;
    }
}
