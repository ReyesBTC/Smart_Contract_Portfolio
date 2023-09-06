// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Importing OpenZeppelin's ERC721, Ownable, and Counters contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title MyToken ERC721 Contract
/// @author Christian Reyes 
/// @notice This contract is an example of an ERC721 token with additional functionalities like airdropping tokens.
/// @dev The contract inherits from OpenZeppelin's ERC721 and Ownable contracts.

contract MyToken is ERC721, Ownable {
    // Using OpenZeppelin's Counters library to manage token IDs
    using Counters for Counters.Counter;

    /// @notice Counter for generating unique token IDs.
    Counters.Counter private _tokenIdCounter;

    /// @notice Array to store addresses eligible for airdrops.
    address[] public publicUsers;

    /// @notice Mapping to store token IDs owned by each address.
    /// @dev Key is the address of the token holder, and value is an array of token IDs.
    mapping(address => uint256[]) public tokens;

    constructor() ERC721("MyToken", "MTK") {
    }

    /// @notice Function to safely mint a new token.
    /// @dev Only the contract owner can mint new tokens.
    /// @param to The address that will receive the minted token.
    function safeMint(address to) public onlyOwner {
        // Generating a new token ID
        uint256 tokenId = _tokenIdCounter.current();
        // Incrementing the token ID counter
        _tokenIdCounter.increment();
        // Minting the new token to the specified address
        _safeMint(to, tokenId);
        // Adding the new token ID to the tokens mapping
        tokens[to].push(tokenId);
    }

    /// @notice Internal function to airdrop tokens to all addresses in the publicUsers array.
    /// @dev This function can only be called by the contract owner.
    function airDrop() private onlyOwner {
        // Looping through all addresses in the publicUsers array
        for (uint i = 0; i < publicUsers.length; i++) {
            // Generating a new token ID
            uint256 tokenId = _tokenIdCounter.current();
            // Minting the new token to the current address in the loop
            _safeMint(publicUsers[i], tokenId);
            // Adding the new token ID to the tokens mapping
            tokens[publicUsers[i]].push(tokenId);
            // Incrementing the token ID counter
            _tokenIdCounter.increment();
        }
    }

    /// @notice Function to trigger the airDrop function. everyone that has been added to the publicUsers array will receive a token.
    /// @dev This function can only be called by the contract owner.
    function triggerAirDrop() public onlyOwner {
        airDrop();
    }

    /// @notice Function to add a new address to the publicUsers array.
    /// @dev This function can only be called by the contract owner.
    /// @param _newUser The address to be added to the publicUsers array.
    function addUser(address _newUser) public onlyOwner {
        publicUsers.push(_newUser);
    }

    /// @notice Function to get the owner of a specific token.
    /// @param tokenId The ID of the token whose owner is to be returned.
    /// @return The address of the owner of the specified token.
    function getOwnerOfToken(uint256 tokenId) public view returns (address) {
        return ownerOf(tokenId);
    }

    /// @notice Function to get the balance of tokens for a specific address.
    /// @param _user The address whose token balance is to be returned.
    /// @return The token balance of the specified address.
    function getBalanceOfAddy(address _user) public view returns (uint256) {
        return balanceOf(_user);
    }
}
