// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Mock Chainlink Oracle
/// @author Christian Reyes 
/// @notice Mock Chainlink Oracle for testing purposes in PseudonymousProofOftradeNFT.t.sol & DynamicAssetPricedNFT.t.sol.
/// @dev This contract mocks the Chainlink oracle for testing purposes.

contract MockChainlinkOracle {
    /// @notice The mocked price value to be returned by the oracle.
    /// @dev This value can be set and retrieved by the contract's methods.
    int256 public price;

    /// @notice Contract constructor that initializes the mock price.
    /// @param _price The initial mock price to be set.
    constructor(int256 _price) {
        price = _price;
    }

    /// @notice Function to simulate Chainlink's latestRoundData function.
    /// @dev This function returns mock data for testing purposes.
    /// @return roundID Mock round ID (always returns 0).
    /// @return answer The current mock price.
    /// @return startedAt Mock startedAt timestamp (always returns 0).
    /// @return updatedAt Mock updatedAt timestamp (always returns 0).
    /// @return answeredInRound Mock answeredInRound (always returns 0).
    function latestRoundData() public view returns (
        uint80 roundID, 
        int256 answer, 
        uint256 startedAt, 
        uint256 updatedAt, 
        uint80 answeredInRound
    ) {
        return (0, price, 0, 0, 0);
    }

    /// @notice Function to set a new mock price.
    /// @dev This function allows you to change the mock price for testing.
    /// @param _price The new mock price to be set.
    function setPrice(int256 _price) public {
        price = _price;
    }
}
