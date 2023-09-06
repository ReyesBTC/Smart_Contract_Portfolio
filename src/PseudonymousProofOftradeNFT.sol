// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Importing Chainlink, OpenZeppelin ERC1155 and Ownable contracts
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Pseudonymous Proof Of tradeNFT V1
 * @author Christian Reyes
 * @notice This contract mints either of two NFTs based on Chainlink price feeds for BTC, ETH, and LINK of trades across multiple CEX or DEX that you purchased a token at a certain price. Future Plans: Add Function to close out the trade. 
 @dev functions mints either of two NFTs based on the last time a certain address called the function. data is based on Chainlink price feeds for BTC, ETH, and LINK and stores the metadata for each token and maps them to the token ID and the pseudonym of the "trader." LIMITATION TO CONSIDER: chainlink prices vs exchange price. For testing purposes, Token ID should be added to the metadata so you can open multiple trades at the same time. 
 */

contract PseudonymousProofOftradeNFT is ERC1155, Ownable {

    // Chainlink price feed interfaces
    AggregatorV3Interface internal _BTCPricefeed;
    AggregatorV3Interface internal _ETHPricefeed;
    AggregatorV3Interface internal _LINKPricefeed;

    // Nonce for generating unique token IDs
    uint256 private nonce = 0;

    // Enum to represent different types of tokens
    enum TokenType { BTC, ETH, LINK }

    /**
    * @dev Struct to hold metadata for each token.
    * @notice Defines trade information
    */
    struct Metadata {
       // string name; // Name of the token
        TokenType tokenType; // Type of the token (BTC, ETH, LINK)
        //uint256 tokenId; // Unique token ID
        string pseudonym; // Pseudonym of the trader
        address source; // Address of the source of the trade (could be a wallet address or a smart contract address Verifies on what exchange trade was made)
        string description; // Description of the token
        string image; // Link to the image of the token
        uint256 openPrice;  // Price of the underlying asset at the time of minting (Open Price)
        uint256 openedTimestamp; // Timestamp when the trade was opened
        uint256 closedTimestamp; // Timestamp when the trade was closed (0 if not closed)
        uint256 closedPrice; // Price of the underlying asset at the time of closing (0 if not closed)
    }

    ///@notice Mapping Token ID to MetaData
    mapping(uint256 => Metadata ) public tokenMetadata;

    ///@notice Mapping Pseudonym to Token ID (Trade open. this allows for groups of traders to compete against each other)
    mapping(string => uint256[]) public pseudonymToTokenIds;

    /**
     * @dev Constructor initializes Chainlink price feed addresses.
     */
    constructor(address, address, address) ERC1155("") {
        //Would be configurable in the future versions.
        // Set addresses for Chainlink price feeds to my mock oricle for testin.  
        _BTCPricefeed = AggregatorV3Interface(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
        _ETHPricefeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        _LINKPricefeed = AggregatorV3Interface(0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c);
    }

    // Event emitted when a new trade is opened
    event TradeOpened(
        uint256 indexed tokenId,
        string pseudonym,
        address indexed source,
        uint256 openPrice,
        uint256 openedTimestamp
    );

    // Event emitted when an existing trade is closed
    event TradeClosed(
        uint256 indexed tokenId,
        string pseudonym,
        address indexed source,
        uint256 closedPrice,
        uint256 closedTimestamp
    );

    /**
    * @notice Opens a new trade and mints a new token based on the latest price feed.
    * @dev This function mints a new token and updates its metadata based on the latest price feed for the specified token type.
    * @param _tkr The type of token to check the price for (BTC, ETH, LINK).
    * @param _pseudonym The pseudonym of the trader.
    * @return Metadata The metadata of the newly minted token.
    */
    function openTrade(TokenType _tkr, string memory _pseudonym) public returns (Metadata memory) {
        //validiate the string
        require(bytes(_pseudonym).length != 0, "Pseudonym cannot be empty");
        uint256 price;
        uint256 tokenId = block.timestamp + nonce;  // Generate a unique token ID

        Metadata memory metadata;

        // Check the token type and update metadata accordingly
        if (_tkr == TokenType.BTC) {
            price = uint256(getBTCLatestPriceFeed()); // Get BTC price feed
            metadata = Metadata({
                tokenType: TokenType.BTC,
                pseudonym: _pseudonym,
                source: msg.sender,
                description: "This is a BTC token minted when the BTC trade was opened",
                image: "https://photobucket.com/BTCHeldbyGaryGenslerimage",
                openPrice: price,
                openedTimestamp: block.timestamp,
                closedTimestamp: 0,
                closedPrice: 0
            });
        } else if (_tkr == TokenType.ETH) {
            price = uint256(getETHLatestPriceFeed()); // Get ETH price feed
            metadata = Metadata({
                tokenType: TokenType.ETH,
                pseudonym: _pseudonym,
                source: msg.sender,
                description: "This is an ETH token minted when the ETH trade was opened.",
                image: "https://photobucket.com/ETHHeldbyGaryGenslerimage",
                openPrice: price,
                openedTimestamp: block.timestamp,
                closedTimestamp: 0,
                closedPrice: 0
            });
        } else if (_tkr == TokenType.LINK) {
            price = uint256(getLINKLatestPriceFeed()); // Get LINK price feed
            metadata = Metadata({
                tokenType: TokenType.LINK,
                pseudonym: _pseudonym,
                source: msg.sender,
                description: "This is a LINK token minted when the Link trade was opened.",
                image: "https://photobucket.com/LINKHeldbyGaryGenslerimage",
                openPrice: price,
                openedTimestamp: block.timestamp,
                closedTimestamp: 0,
                closedPrice: 0
            });
        }

        // Associate metadata with token ID
        tokenMetadata[tokenId] = metadata;

        // Associate metadata with pseudonym
        pseudonymToTokenIds[_pseudonym].push(tokenId);

        // Mint the token with the new token ID
        _mint(msg.sender, tokenId, 1, "");

        // Increment the nonce for the next token ID
        nonce++;

        // Emit TradeOpened event
        emit TradeOpened(tokenId, _pseudonym, msg.sender, price, block.timestamp);
        
        return metadata;
    }

    /**
    * @notice Close an open trade and update the token's metadata.
    * @dev This function allows the owner of a token to close their trade. It updates the metadata of the token based on the latest price feed.
    * @param tokenId The ID of the token to close the trade for.
    * @return updatedMetadata The updated metadata after closing the trade.
    */
    function closeTrade(uint256 tokenId, string memory _pseudonym) public returns (Metadata memory) {
        // Fetch existing metadata for the token
        Metadata memory existingMetadata = tokenMetadata[tokenId];

        // Verify the source
        require(existingMetadata.source == msg.sender, "Only the source of the trade can close it");

        // // Verify the pseudonym
        require(keccak256(abi.encodePacked(_pseudonym)) == keccak256(abi.encodePacked(existingMetadata.pseudonym)), "Pseudonym does not match");

        // Check if the trade is already closed
        require(existingMetadata.closedTimestamp == 0, "Trade is already closed");

        // Initialize updated metadata with existing values
        Metadata memory updatedMetadata = existingMetadata;

        uint256 price; // Variable to hold the latest price

        // Close trade for BTC
        if (existingMetadata.tokenType == TokenType.BTC) {
            price = uint256(getBTCLatestPriceFeed()); // Fetch the latest BTC price
            updatedMetadata.closedPrice = price; // Update the closed price in metadata
            updatedMetadata.closedTimestamp = block.timestamp; // Update the closed timestamp in metadata
            // Update the image based on whether the price went up or down
            if (price > existingMetadata.openPrice) {
                updatedMetadata.image = "https://photobucket.com/BTC_bull_closed";
            } else {
                updatedMetadata.image = "https://photobucket.com/BTC_bear_closed";
            }
        } 
        // Close trade for ETH
        else if (existingMetadata.tokenType == TokenType.ETH) {
            price = uint256(getETHLatestPriceFeed()); // Fetch the latest ETH price
            updatedMetadata.closedPrice = price; // Update the closed price in metadata
            updatedMetadata.closedTimestamp = block.timestamp; // Update the closed timestamp in metadata
            // Update the image based on whether the price went up or down
            if (price > existingMetadata.openPrice) {
                updatedMetadata.image = "https://photobucket.com/ETH_bull_closed";
            } else {
                updatedMetadata.image = "https://photobucket.com/ETH_bear_closed";
            }
        } 
        // Close trade for LINK
        else if (existingMetadata.tokenType == TokenType.LINK) {
            price = uint256(getLINKLatestPriceFeed()); // Fetch the latest LINK price
            updatedMetadata.closedPrice = price; // Update the closed price in metadata
            updatedMetadata.closedTimestamp = block.timestamp; // Update the closed timestamp in metadata
            // Update the image based on whether the price went up or down
            if (price > existingMetadata.openPrice) {
                updatedMetadata.image = "https://photobucket.com/LINK_bull_closed";
            } else {
                updatedMetadata.image = "https://photobucket.com/LINK_bear_closed";
            }
        }

       // Verify the pseudonym
        require(keccak256(abi.encodePacked(_pseudonym)) == keccak256(abi.encodePacked(existingMetadata.pseudonym)), "Pseudonym does not match");

        updatedMetadata.description = "This trade has been closed"; // Update the description in metadata

        // Update the metadata for the token
        tokenMetadata[tokenId] = updatedMetadata;

        // Emit TradeClosed event
        emit TradeClosed(tokenId, existingMetadata.pseudonym, existingMetadata.source, updatedMetadata.closedPrice, updatedMetadata.closedTimestamp);

        return updatedMetadata;
    }

    ///@notice Function to get the tokenid by pseudonym (this allows for groups of traders to compete against each other)
    ///@dev This function is used to get the tokenid by pseudonym (this allows for groups of traders to compete against each other)
    ///@param _pseudonym The pseudonym of the trader
    function getTokenIdsByPseudonym(string memory _pseudonym) public view returns (uint256[] memory) {
        return pseudonymToTokenIds[_pseudonym];
    }

    ///@notice Function to get BTC price feed from Chainlink
    ///@dev Uses Chainlink address for BTC price feed
    // Internal functions to get the latest price feeds
    function getBTCLatestPriceFeed() internal view returns (int) {
        (, int price, , , ) = _BTCPricefeed.latestRoundData();
        return price;
    }

    function getETHLatestPriceFeed() internal view returns (int) {
        (, int price, , , ) = _ETHPricefeed.latestRoundData();
        return price;
    }

    function getLINKLatestPriceFeed() internal view returns (int) {
        (, int price, , , ) = _LINKPricefeed.latestRoundData();
        return price;
    }

    /**
     * @notice Allows the owner to set a new URI for the metadata.
     * @param newuri The new URI.
     */
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

}
