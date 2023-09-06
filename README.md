# Porfolio 
### Feature Cap Stone Projects 

#### MultiSigWallet (In-depth testing) 
<p align="left">
    The MultiSigWallet contract serves as a robust testing ground for multi-signature governance in Solidity with Foundry, incorporating a comprehensive set of features to validate various scenarios. It employs four distinct structs and multiple state variables and mappings to manage transactions and administrative changes, all of which are subject to a quorum of owner approvals. The contract is meticulously designed to be testable, with each function and state change emitting specific events for easy tracking and validation. This allows for extensive unit testing, ensuring that each component—from access control enforced through modifiers to the initialization of owners and quorum via the constructor—functions as intended. Each function is thoroughly tested. The inclusion of receive() and fallback() functions also allows for the testing of Ether handling within the contract.
</p>
</br> 

#### Pseudonymous Proof Of tradeNFT V1 (Chainlink data & Dynamic NFT’s)
<p align="left">
    The PseudonymousProofOfTradeNFT contract is engineered to facilitate pseudonymous immutable trading records of cryptocurrencies including BTC, ETH, and LINK. It integrates Chainlink oracles for real-time price data acquisition and is built on the ERC-1155 token standard for multi-token support. The contract employs a struct, Metadata, to encapsulate trade-specific details such as token type, pseudonym, and associated prices. This dynamic token's properties are updated based on the elements in the Metadata, which are subject to change over time and through function calls. The system includes a comprehensive test suite, with some tests pending debugging. Future iterations aim to introduce features like trade history tracking, trading competition and general proof of trades.
</p>
</br> 

#### Dynamic Asset Priced NFT (Chainlink data & Dynamic NFT's)
<p align="left">
    The DynamicAssetPricedNFT contract leverages Chainlink oracles for real-time price feeds of BTC, ETH, and LINK to mint ERC-1155 NFTs. Each NFT type can only be minted once per address and dynamically changes its metadata based on the latest price feed. The contract employs a struct called Metadata to encapsulate token attributes like name, description, image, and price. A comprehensive test suite is planned for future development, focusing on the hasMinted mapping, metadata verification based on price feeds, and mocking Chainlink price feeds for controlled testing. This contract serves as a robust testing ground for Chainlink integration, dynamic metadata manipulation, and ERC-1155 token standards.
</p>
</br>

#### Mock Chainlink Oracle (Provides Price Feed for testing Pseudonymous Proof Of tradeNFT V1 & Dynamic Asset Priced NFT)
<p align="left">
    The MockChainlinkOracle contract serves as a testing utility for simulating Chainlink oracle behavior in smart contracts like PseudonymousProofOftradeNFT and DynamicAssetPricedNFT. It allows for the manual setting of price data, mimicking Chainlink's latestRoundData function to return this mock price. The contract is initialized with an initial mock price and provides a method to update this price. This mock setup is instrumental for unit testing, enabling the validation of Chainlink-dependent logic in a controlled environment. The contract is particularly useful for testing how other contracts handle dynamic price data without interacting with actual Chainlink oracles, thereby streamlining the development and debugging process.
</p>
</br>

#### ERC-721 token air-dropping system
<p align="left">
    The MyToken contract is an example of an ERC721 token with added functionalities like airdropping tokens to a list of public users. Built on Solidity 0.8.13, it leverages OpenZeppelin's ERC721, Ownable, and Counters libraries for standard token features, ownership management, and unique token ID generation, respectively. The contract allows only the owner to mint new tokens and add users to an airdrop list. An internal function, airDrop, iterates through this list to mint tokens for each user. The contract also provides utility functions to query token ownership and balance. This contract serves as a comprehensive example of how to extend basic ERC721 functionality with additional features, making it a useful template for various NFT-based applications.
</p>
</br>
