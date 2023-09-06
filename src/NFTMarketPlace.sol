// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title NFT Marketplace Contract 
/// @author Christian Reyes 
/// @notice NFT Marketplace Contract for Testing Purposes with Foundry
/// @dev under construction

interface INFTMarketplace {
    function register() external;
    function unregister() external;
    function listNFT(uint256 tokenId, uint256 price) external;
    function delistNFT(uint256 tokenId) external;
    function buyNFT(uint256 tokenId) external payable;
}
