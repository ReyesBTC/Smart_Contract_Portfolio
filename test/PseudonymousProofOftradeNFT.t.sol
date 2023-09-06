// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../src/PseudonymousProofOftradeNFT.sol";
import "../src/MockChainlinkOracle.sol";

/**
 * @title PseudonymousProofOftradeNFTTest
 * @author Christian Reyes
 * @notice This contract tests the functionalities of the PseudonymousProofOftradeNFT contract.
 * @dev This contract is used for testing the PseudonymousProofOftradeNFT contract, and calls from a Mock ChainLink Oricle.
 */
contract PseudonymousProofOftradeNFTTest is Test {
    PseudonymousProofOftradeNFT tradeNFT;
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
        tradeNFT = new PseudonymousProofOftradeNFT(address(mockBTCOracle), address(mockETHOracle), address(mockLINKOracle));  // Initialize your main contract
    }

    /**
     * @dev Tests the behavior of opening a trade.
     */
    function test_OpenTrade() public {
        PseudonymousProofOftradeNFT.Metadata memory metadata = tradeNFT.openTrade(PseudonymousProofOftradeNFT.TokenType.BTC, "Alice");
        assertEq0(bytes(metadata.pseudonym), bytes("Alice"));
        assertEq(uint(metadata.tokenType), uint(PseudonymousProofOftradeNFT.TokenType.BTC));
        assertEq(metadata.openedTimestamp, block.timestamp);
    }

    /**
     * @dev Tests the behavior of closing a trade.
     * Asserts that the closed price in the new metadata is above 0.
     */
    function test_CloseTrade() public {
        PseudonymousProofOftradeNFT.Metadata memory openedMetadata = tradeNFT.openTrade(PseudonymousProofOftradeNFT.TokenType.BTC, "Alice");
        uint256 openedTimestamp = openedMetadata.openedTimestamp;
        PseudonymousProofOftradeNFT.Metadata memory closedMetadata = tradeNFT.closeTrade(openedTimestamp, "Alice");

        assertTrue(closedMetadata.closedPrice > 0);
    }

    /**
     * @dev Tests the behavior when trying to open a trade with an empty pseudonym.
     * This test is expected to revert.
     */
    function testFail_OpenTradeEmptyPseudonym() public {
        tradeNFT.openTrade(PseudonymousProofOftradeNFT.TokenType.BTC, "");
    }

    /**
     * @dev Tests the behavior when trying to close a trade with an invalid pseudonym.
     * This test is expected to revert.
     */
    function testFail_CloseTradeInvalidPseudonym() public {
        tradeNFT.openTrade(PseudonymousProofOftradeNFT.TokenType.BTC, "Alice");
        tradeNFT.closeTrade(block.timestamp, "Bob");
    }

    /**
     * @dev Tests the behavior when trying to close a trade with an invalid timestamp.
     * This test is expected to revert.
     */
    function testFail_CloseTradeInvalidTimestamp() public {
        tradeNFT.openTrade(PseudonymousProofOftradeNFT.TokenType.BTC, "Alice");
        tradeNFT.closeTrade(block.timestamp + 1, "Alice");
    }
}

/**
 * @dev === Notes for Future Development and Debugging ===
 * 
 * 1. Failing Tests:
 *    - test_CloseTrade() is currently failing due to an EVM Revert. 
 *    - test_OpenTrade() is also failing for the same reason.
 * 
 * 2. Debugging Plan:
 *    a. Investigate the "EvmError: Revert" in both test_CloseTrade() and test_OpenTrade().
 *       - Check if the mock Chainlink oracles are properly set and returning expected values.
 *       - Examine the `latestRoundData()` static calls to ensure they are functioning as expected.
 *    b. Validate the state changes in the main contract to ensure they are consistent with the test expectations.
 *    c. Use debuggers or console.log statements to trace contract execution.
 *    d. Consider writing more granular tests to isolate the issue.
 * 
 * 3. Additional Test Cases:
 *    - Once the above issues are resolved, additional test cases will be written to cover edge cases and ensure robustness.
 * 
 * 4. Code Refactoring:
 *    - After ensuring all tests pass, the code will be reviewed for possible optimizations and refactoring.
 * 
 * 5. Documentation:
 *    - Comprehensive documentation will be added once the contract is stable and all tests pass.
 * 
 * This note serves as a guide for the next steps in the development and debugging process.
 */
