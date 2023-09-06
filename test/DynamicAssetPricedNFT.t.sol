// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Dynamic Asset PricedNFT
/// @author Christian Reyes 
/// @notice Tests the DynamicAssetPricedNFT contract
/// @dev This contract tests the DynamicAssetPricedNFT contract

import "forge-std/Test.sol";
import "../src/DynamicAssetPricedNFT.sol";
import "../src/MockChainlinkOracle.sol"; // Import the mock Chainlink oracle 

contract DynamicAssetPricedNFTTest is Test {
    DynamicAssetPricedNFT dynamicAssetPricedNFT;
    MockChainlinkOracle mockBTCOracle;
    MockChainlinkOracle mockETHOracle;
    MockChainlinkOracle mockLINKOracle;

    /**
     * @dev Sets up the initial environment for each test.
     * Initializes mock Chainlink oracles and the main contract.
     */
    function setUp() public {
        mockBTCOracle = new MockChainlinkOracle(100000);  // Set initial BTC price to 100000
        mockETHOracle = new MockChainlinkOracle(3000);  // Set initial ETH price to 3000
        mockLINKOracle = new MockChainlinkOracle(100);  // Set initial LINK price to 100
        dynamicAssetPricedNFT = new DynamicAssetPricedNFT(address(mockBTCOracle), address(mockETHOracle), address(mockLINKOracle));  // Initialize your main contract
    }

    /// @dev Tests the behavior of getting the latest price for BTC.
    function test_GetLatestPriceForBTC() public {
        DynamicAssetPricedNFT.Metadata memory metadata = dynamicAssetPricedNFT.getLatestPrice(DynamicAssetPricedNFT.TokenType.BTC);
        
        // Hypothetical expected values
        uint256 expectedPrice = 50000;  
        
        assertEq(metadata.price, expectedPrice);
    }

    /// @dev Tests the behavior of getting the latest price for ETH.
    function test_GetLatestPriceForETH() public {
        DynamicAssetPricedNFT.Metadata memory metadata = dynamicAssetPricedNFT.getLatestPrice(DynamicAssetPricedNFT.TokenType.ETH);
        
        // Hypothetical expected values
        uint256 expectedPrice = 3000;  
        
        assertEq(metadata.price, expectedPrice);
    }

    /// @dev Tests the behavior of getting the latest price for LINK.
    function test_GetLatestPriceForLINK() public {
        DynamicAssetPricedNFT.Metadata memory metadata = dynamicAssetPricedNFT.getLatestPrice(DynamicAssetPricedNFT.TokenType.LINK);
        
        // Hypothetical expected values
        uint256 expectedPrice = 25;  
        
        assertEq(metadata.price, expectedPrice);
    }
}

/**
 * @dav=== Notes for Future Development and Debugging ===
 * 1. Consider adding tests for the `hasMinted` mapping to ensure an address can only mint each token type once.
 * 2. Add tests to verify the metadata (name, description, image) based on the price feed.
 * 3. Consider mocking the Chainlink price feeds for more controlled testing.
 * 4. Add tests for the `updateMetadataHourly` function once it's implemented.
  */