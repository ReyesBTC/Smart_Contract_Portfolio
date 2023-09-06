// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/// @title Test Interface for MyToken Contract's Airdrop Functionality
/// @author Christian Reyes 
/// @notice This interface is designed for testing the airdrop functionality of the MyToken contract.
/// @dev This is a test interface for mocking and testing purposes.

interface ITestMyTokenAirdrop {
    
    /// @notice Mock function to test the safeMint function in the MyToken contract.
    /// @param to The address to which the token will be minted.
    /// @param tokenId The ID of the token to be minted.
    /// @return A boolean value indicating whether the operation was successful.
    function testSafeMint(address to, uint256 tokenId) external returns (bool);

    /// @notice Mock function to test the airDrop function in the MyToken contract.
    /// @param users An array of addresses to which tokens will be airdropped.
    /// @return A boolean value indicating whether the operation was successful.
    function testAirDrop(address[] calldata users) external returns (bool);

    /// @notice Mock function to test the triggerAirDrop function in the MyToken contract.
    /// @return A boolean value indicating whether the operation was successful.
    function testTriggerAirDrop() external returns (bool);

    /// @notice Mock function to test the addUser function in the MyToken contract.
    /// @param newUser The address to be added to the publicUsers array.
    /// @return A boolean value indicating whether the operation was successful.
    function testAddUser(address newUser) external returns (bool);

    /// @notice Mock function to test the getOwnerOfToken function in the MyToken contract.
    /// @param tokenId The ID of the token whose owner is to be returned.
    /// @return The address of the owner of the specified token.
    function testGetOwnerOfToken(uint256 tokenId) external view returns (address);

    /// @notice Mock function to test the getBalanceOfAddy function in the MyToken contract.
    /// @param user The address whose token balance is to be returned.
    /// @return The token balance of the specified address.
    function testGetBalanceOfAddy(address user) external view returns (uint256);
}
