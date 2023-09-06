// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Import Chainlink, OpenZeppelin ERC1155, and Ownable contracts
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Dynamic Asset Priced NFT
 * @author Christian Reyes
 * @dev This contract mints NFTs based on Chainlink price feeds for BTC, ETH, and LINK.
 * Each token type (BTC, ETH, LINK) can only be minted once per address.
 * The metadata for each token type changes based on the latest price feed.
 */
contract DynamicAssetPricedNFT is ERC1155, Ownable {
    // Chainlink price feed interfaces
    AggregatorV3Interface internal _BTCPricefeed;
    AggregatorV3Interface internal _ETHPricefeed;
    AggregatorV3Interface internal _LINKPricefeed;

    // Enum to represent different types of tokens
    enum TokenType { BTC, ETH, LINK }

    // Struct to hold metadata for each token
    struct Metadata {
        string name;
        string description;
        string image;
        uint256 price;
    }

    // Mapping to store metadata for each token type
    mapping(TokenType => Metadata) public tokenMetadata;

    // Mapping to track which addresses have minted each token type
    mapping(address => mapping(TokenType => bool)) public hasMinted;

    /**
     * @dev Constructor to initialize Chainlink price feed addresses.
     *  _BTCPricefeed = AggregatorV3Interface(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
     *  _ETHPricefeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
     *  _LINKPricefeed = AggregatorV3Interface(0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c);
     * @param BTCPricefeed Chainlink price feed address for BTC/USD.
     * @param ETHPricefeed Chainlink price feed address for ETH/USD.
     * @param LINKPricefeed Chainlink price feed address for LINK/USD.
     * @dev The constructor initializes the Chainlink price feed addresses // working on this.
     */
    constructor(address BTCPricefeed, address ETHPricefeed, address LINKPricefeed) ERC1155("") {
        _BTCPricefeed = AggregatorV3Interface(BTCPricefeed);
        _ETHPricefeed = AggregatorV3Interface(ETHPricefeed);
        _LINKPricefeed = AggregatorV3Interface(LINKPricefeed);
    }

    /**
     * @notice Get the latest price and mint a new token based on the price feed.
     * @param _tkr The type of token to check the price for (BTC, ETH, LINK).
     * @return Metadata for the minted token.
     */
    function getLatestPrice(TokenType _tkr) public returns (Metadata memory) {
        require(!hasMinted[msg.sender][_tkr], "You have already minted this token type.");

        uint256 price;
        Metadata memory metadata;

        // Get the latest price from Chainlink based on token type
        if (_tkr == TokenType.BTC) {
            price = uint256(getBTCLatestPriceFeed());
        } else if (_tkr == TokenType.ETH) {
            price = uint256(getETHLatestPriceFeed());
        } else if (_tkr == TokenType.LINK) {
            price = uint256(getLINKLatestPriceFeed());
        }

        if (tokenMetadata[_tkr].price > price) {
            metadata = Metadata({
                name: "Bear Token",
                description: "Price is lower than last checked.",
                image: "https://example.com/bear_image",
                price: price
            });
        } else {
            metadata = Metadata({
                name: "Bull Token",
                description: "Price is higher than last checked.",
                image: "https://example.com/bull_image",
                price: price
            });
        }

        tokenMetadata[_tkr] = metadata;
        hasMinted[msg.sender][_tkr] = true;

        _mint(msg.sender, uint256(_tkr), 1, "");

        return metadata;
    }

    /**
     * @notice Placeholder for a function that could be called every hour to update metadata.
     */
    function updateMetadataHourly() public {
        // Placeholder for the function that could be called every hour to update metadata
    }

    /**
     * @dev Internal function to get the latest BTC price from Chainlink.
     * @return Latest BTC price.
     */
    function getBTCLatestPriceFeed() internal view returns (int) {
        (, int price, , , ) = _BTCPricefeed.latestRoundData();
        return price;
    }

    /**
     * @dev Internal function to get the latest ETH price from Chainlink.
     * @return Latest ETH price.
     */
    function getETHLatestPriceFeed() internal view returns (int) {
        (, int price, , , ) = _ETHPricefeed.latestRoundData();
        return price;
    }

    /**
     * @dev Internal function to get the latest LINK price from Chainlink.
     * @return Latest LINK price.
     */
    function getLINKLatestPriceFeed() internal view returns (int) {
        (, int price, , , ) = _LINKPricefeed.latestRoundData();
        return price;
    }
}

/**
 * @dav=== Notes for Future Development and Debugging ===
 * 1. Considering adding tests for the `hasMinted` mapping to ensure an address can only mint each token type once. 
 * 2. Add tests to verify the metadata (name, description, image) based on the price feed.
 * 3. Trying to create a mock Chainlink price feed for more controlled testing.
 * 4. Add tests for the `updateMetadataHourly` function once it's implemented.
  */