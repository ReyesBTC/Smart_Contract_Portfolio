// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Counter
/// @notice A simple counter
/// @dev This is only for testing in Foundry purposes
/// @custom:experimental This is an experimental contract 

contract Counter {

    ///@notice The current value of the counter
    uint256 public number;

    ///@notice Sets the value of the counter
    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    ///@notice Increments the value of the counter
    function increment() public {
        number++;
    }
}
