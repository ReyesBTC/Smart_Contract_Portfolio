// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Test Interface for NFT Marketplace Contract
/// @author Christian Reyes
/// @notice Test Interface for NFT Marketplace Contract to be used in testing with Foundry
/// @dev This is a test interface for mocking and testing purposes

interface ITestNFTMarketplace {
    function testRegister(address user) external returns (bool);
    function testUnregister(address user) external returns (bool);
    function testListNFT(address user, uint256 tokenId, uint256 price) external returns (bool);
    function testDelistNFT(address user, uint256 tokenId) external returns (bool);
    function testBuyNFT(address buyer, address seller, uint256 tokenId, uint256 price) external returns (bool);
}

