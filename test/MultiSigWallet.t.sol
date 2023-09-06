// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {MultiSigWallet} from "../src/MultiSigWallet.sol";  // Import the MultiSigWallet contract

/// @title MultiSigWallet Deployment Test
/// @author Christian Reyes 
/// @notice This test suite checks the deployment of the MultiSigWallet contract
/// @dev The test uses the DappSys testing framework

contract MultiSigWalletTest is Test {

    /// @notice The instance of the MultiSigWallet contract for testing
    MultiSigWallet public multiSigWallet;

    /// @notice The list of owner addresses for the MultiSigWallet
    address[] public initialOwners;

    /// @notice The quorum required for transactions
    uint public initialQuorum;

    /// @dev This function runs before each test case
    function setUp() public {
        // Initialize the list of owners and the quorum
        initialOwners = [address(0x123), address(0x456), address(0x789)];  // Replace with actual addresses
        initialQuorum = 2;  // Replace with the actual quorum
        multiSigWallet = new MultiSigWallet(initialOwners, initialQuorum);
    }

    /// @notice Test the deployment of the MultiSigWallet contract
    /// @dev This test checks whether the contract deploys without reverting
    function test_deployMultiSigWallet() public {
        // Deploy the MultiSigWallet contract
        multiSigWallet = new MultiSigWallet(initialOwners, initialQuorum);

        // Check if the contract address is not zero
        assertTrue(address(multiSigWallet) != address(0), "Contract deployment failed");
    }

    /// @notice Test if the contract is initialized with correct owners and quorum
    /// @dev This test checks whether the contract is initialized with the correct owners and quorum
    function test_ConstructorInitialization() public {
        // Fetch the owners and quorum from the contract
        address[] memory owners = multiSigWallet.getOwners();
        uint quorum = multiSigWallet.quorum();
        // Assert that the length of the owners array matches the initial length
        assertEq(owners.length, initialOwners.length);
        // Loop through the array to compare each element individually
        for (uint i = 0; i < initialOwners.length; i++) {
            assertEq(owners[i], initialOwners[i]);
        }
        // Assert that the quorum matches the initial quorum
        assertEq(quorum, initialQuorum);
    }


    /// @notice Test if the contract is initialized with correct owners and quorum
    function test_NumberofOwners() public {
        assertEq(multiSigWallet.getOwners().length, 3);
        assertEq(multiSigWallet.quorum(), 2);
    }

    function test_Quorum() public {
        assertEq(multiSigWallet.quorum(), 2);
    }

    //Receiver & Fallback Test

    /// @notice Test the receive function
    /// @dev This test checks whether the contract can receive Ether
    function test_ReceiveEther() public {
        // Initial balance of the contract
        uint initialBalance = multiSigWallet.getBalance();
        // Amount to be sent
        uint amountToSend = 1000;
        // Send Ether to the contract
        payable(address(multiSigWallet)).transfer(amountToSend);
        // New balance of the contract
        uint newBalance = multiSigWallet.getBalance();
        // Assert that the new balance is correct
        assertEq(newBalance, initialBalance + amountToSend);
    }

    /// @notice Test if the contract correctly handles the fallback function 
    /// @dev This test function sends Ether to the contract without calling any specific function, triggering the fallback.
    function test_FallbackFunction() public {
        // Initial balance of the contract
        uint initialBalance = multiSigWallet.getBalance();
        // Amount to be sent to trigger the fallback function
        uint amountToSend = 1000;
        // Send Ether to the contract without calling any function to trigger the fallback and save the return value in tuple
        (bool success, ) = address(multiSigWallet).call{value: amountToSend}("");
        require(success, "Fallback failed");
        // New balance of the contract
        uint newBalance = multiSigWallet.getBalance();
        // Assert that the new balance is correct
        assertEq(newBalance, initialBalance + amountToSend);
    }

    //Modifiers tests

    /// @notice Test the onlyOwners modifier
    /// @dev This test checks whether a function with the onlyOwners modifier reverts when called by a non-owner
    function test_onlyOwnersModifier() public {
        // behave as a non-owner
        vm.startPrank(address(0xABC)); // Signs w/ address that's not an owner.
        try multiSigWallet.proposeTransaction(1000, payable(address(0x123))) {
            // This should fail
            assertTrue(false, "Should have reverted");
        } 
        catch {
            // This should pass
            assertTrue(true, "Correctly reverted");
        }
        vm.stopPrank();
    }

    /// @notice Test the onlyOwners modifier Rrverts
    /// @dev This test checks whether a function with the onlyOwners modifier reverts when called by a non-owner
    function test_OnlyModifier() public {
        // behave as a non-owner
        vm.startPrank(address(0xABC)); // Signs w/ address that's not an owner.
        try multiSigWallet.proposeTransaction(1000, payable(address(0x123))) {
            // This should fail
            assertTrue(false, "Should have reverted");
        } 
        catch {
            // This should pass
            assertTrue(true, "Correctly reverted");
        }
        vm.stopPrank();
    }

    /// @notice Test the ownerExists modifier
    /// @dev This test checks whether a function with the ownerExists modifier reverts when called by a non-existing owner
    function test_ownerExistsModifier() public {
        // behave as a non-existing owner
        vm.startPrank(address(0xDEF));
        try multiSigWallet.proposeTransaction(1000, payable(address(0x123))) {
            // This should fail
            assertTrue(false, "Should have reverted");
        } 
        catch {
            // This should pass
            assertTrue(true, "Correctly reverted");
        }
        vm.stopPrank();
    }

    ///@notice Test the ownerExists modifier reverts
    ///@dev This test checks whether a function with the ownerExists modifier reverts when called by a non-existing owner
    function test_Onlymodifier() public {
        // behave as a non-existing owner
        vm.startPrank(address(0xDEF));
        try multiSigWallet.proposeTransaction(1000, payable(address(0x123))) {
            // This should fail
            assertTrue(false, "Should have reverted");
        } 
        catch {
            // This should pass
            assertTrue(true, "Correctly reverted");
        }
        vm.stopPrank();
    }

    // Getter functions tests

    /// @notice Test the getBalance function
    /// @dev This test checks whether the getBalance function returns the correct balance
    function test_getOwners() public {
        address[] memory owners = multiSigWallet.getOwners();
        assertEq(owners.length, 3);
        for (uint i = 0; i < initialOwners.length; i++) {
            assertEq(owners[i], initialOwners[i]);
        }
    }

    /// @notice Test the gettransactions returns an array of transactions
    /// @dev This test checks whether the getTransactions function returns the array of transactions and each element in the custum struct is correct
    function test_getTransactions() public {
        // Deposit extra ether into the contract
        payable(address(multiSigWallet)).transfer(5000);
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        vm.stopPrank(); 

        // Get the transactions count from the contract
        uint count = multiSigWallet.getTransactionsCount();
        assertEq(count, 3);

        // Manually create each expected transaction
        MultiSigWallet.Transaction memory expectedTransaction1 = MultiSigWallet.Transaction({
            id: 0,
            amount: 1000,
            to: payable(address(0x123)),
            approvals: 0,
            executed: false
        });

        MultiSigWallet.Transaction memory expectedTransaction2 = MultiSigWallet.Transaction({
            id: 1,
            amount: 1000,
            to: payable(address(0x123)),
            approvals: 0,
            executed: false
        });

        MultiSigWallet.Transaction memory expectedTransaction3 = MultiSigWallet.Transaction({
            id: 2,
            amount: 1000,
            to: payable(address(0x123)),
            approvals: 0,
            executed: false
        });

    MultiSigWallet.Transaction[] memory actualTransactions = multiSigWallet.getTransactions();

    // Loop through each transaction and compare each field
    for (uint i = 0; i < count; i++) {
    MultiSigWallet.Transaction memory actualTransaction = actualTransactions[i];
    MultiSigWallet.Transaction memory expectedTransaction;

    // Assign the expected transaction based on the index
        if (i == 0) {
                expectedTransaction = expectedTransaction1;
            } else if (i == 1) {
                expectedTransaction = expectedTransaction2;
            } else if (i == 2) {
                expectedTransaction = expectedTransaction3;
            }

            // Perform the assertions
            assertEq(actualTransaction.id, expectedTransaction.id, "Mismatch in transaction ID");
            assertEq(actualTransaction.amount, expectedTransaction.amount, "Mismatch in transaction amount");
            assertEq(actualTransaction.to, expectedTransaction.to, "Mismatch in transaction recipient");
            assertEq(actualTransaction.approvals, expectedTransaction.approvals, "Mismatch in transaction approvals");
            assertTrue(actualTransaction.executed == expectedTransaction.executed, "Mismatch in transaction execution status");
        }
    }

    ///@notice Test the getTransactionsCount function
    ///@dev This test checks whether the getTransactions by an transaction ID returns a transaction
    function test_getTransactionsByIndex() public {
        // Deposit extra ether into the contract
        payable(address(multiSigWallet)).transfer(5000);
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        assertEq(multiSigWallet.getTransactionsCount(), 2); 
        vm.stopPrank(); 
        uint count = multiSigWallet.getTransactionsCount();
        assertEq(count, 2);
        // Choose the second transaction index[1] and check its properties 
                MultiSigWallet.Transaction memory txn = multiSigWallet.getTransactionByIndex(1);
                MultiSigWallet.Transaction memory expectedTransaction = MultiSigWallet.Transaction({
                    id: 1,
                    amount: 1000,
                    to: payable(address(0x123)),
                    approvals: 0,
                    executed: false
                });

            assertEq(txn.id, expectedTransaction.id);
            assertEq(txn.amount, expectedTransaction.amount);
            assertEq(txn.to, expectedTransaction.to);
            assertEq(txn.approvals, expectedTransaction.approvals);
            assertTrue(txn.executed == expectedTransaction.executed);
            }

    ///@notice Test the getTransactionsCount function with incorrect ID
    ///@dev This test checks whether the getTransactions wrong transaction ID returns a transaction
    function testFail_getTransactionsByIndex() public {
        // Deposit extra ether into the contract
        payable(address(multiSigWallet)).transfer(5000);
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        assertEq(multiSigWallet.getTransactionsCount(), 2); 
        vm.stopPrank(); 
        uint count = multiSigWallet.getTransactionsCount();
        assertEq(count, 2);
        // choose the second transaction index[1] and check its properties 
                MultiSigWallet.Transaction memory txn = multiSigWallet.getTransactionByIndex(2);
                MultiSigWallet.Transaction memory expectedTransaction = MultiSigWallet.Transaction({
                    id: 1,
                    amount: 1000,
                    to: payable(address(0x123)),
                    approvals: 0,
                    executed: false
                });

            assertEq(txn.id, expectedTransaction.id);
            assertEq(txn.amount, expectedTransaction.amount);
            assertEq(txn.to, expectedTransaction.to);
            assertEq(txn.approvals, expectedTransaction.approvals);
            assertTrue(txn.executed == expectedTransaction.executed);
            }
    
    ///@notice Test the getTransactionsCount 
    function test_getTransactionCount() public {
        payable(address(multiSigWallet)).transfer(1000);
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        assertEq(multiSigWallet.getTransactionsCount(), 1); 
    }

    ///@notice Test the getBalances function
    function test_getBalance() public {
        payable(address(multiSigWallet)).transfer(1000);
        assertEq(multiSigWallet.getBalance(), 1000); 
    }

    // Test Complete Transaction

    /// @notice Test the transaction workflow from proposal to execution
    /// @dev This test checks function propose, approval and execution with correct arguments.
    function test_TransactionWorkflow() public {
        // Deposit some ether into the contract
        payable(address(multiSigWallet)).transfer(1000);
        // Propose a new transaction
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        // Check that the transaction is proposed
        assertEq(multiSigWallet.getTransactionsCount(), 1); 
        //checked that transaction is created and accounted for. 
        multiSigWallet.approveTransaction(0); 
        vm.stopPrank(); 

	    // behave as owner
        vm.startPrank(address(0x456));
        multiSigWallet.approveTransaction(0); 
	    vm.stopPrank();
        // Check that the transaction is approved
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 2);
        // Step 3: Check if the transaction is executed
        assertTrue(multiSigWallet.getTransactionByIndex(0).executed);
        // Step 4: Check if the balance of the contract has been reduced
        assertEq(multiSigWallet.getBalance(), 0);
    }

    /// @notice Testing proposeTransaction function require statement
    /// @dev This test require statement that checks whether the transaction proposal reverts when called with incorrect arguments.
    function testFail_TransactionProposalNoFunds() public {
        // Propose a new transaction with incorrect insufficent balance
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
    }

    /// @notice Test the transaction proposal w/ none owner
    /// @dev This test checks the modifier, whether the transaction proposal reverts when called with incorrect address.
    function testFail_newTransactionProposalNoneOwner() public {
        // Deposit some ether into the contract
        payable(address(multiSigWallet)).transfer(1000);
        // Propose a new transaction
        vm.startPrank(address(0x890));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
    }

    ///@notice Test revoke Approval 
    function test_revokeApproval() public {
        // Deposit some ether into the contract
        payable(address(multiSigWallet)).transfer(1000);
        // Propose a new transaction
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        // Check that the transaction is proposed
        assertEq(multiSigWallet.getTransactionsCount(), 1); 
        //checked that transaction is created and accounted for. 
        multiSigWallet.approveTransaction(0); 
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 1);
        multiSigWallet.revokeApproval(0);
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 0);
    }

    ///@notice Test revoke Approval require for transaction that already excecuted
    ///@dev This test checks whether the transaction proposal reverts when called with id of an exceuted transaction.
    function testFail_revokeApprovalExecutedTxn() public {
        // Deposit some ether into the contract
        payable(address(multiSigWallet)).transfer(1000);
        // Propose a new transaction
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        // approve the transaction
        multiSigWallet.approveTransaction(0); 
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 1);
        vm.prank(address(0x456));
        multiSigWallet.revokeApproval(0);
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 0);
        vm.stopPrank();
    }

    ///@notice Test revoke Approval "from another" (also without prior approval) owner
    ///@dev This test checks whether the transaction proposal reverts when called from an owner that has not approved the transaction.
    function testFail_revokeApproval() public {
        // Deposit some ether into the contract
        payable(address(multiSigWallet)).transfer(1000);
        // Propose a new transaction
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        // Check that the transaction is proposed
        assertEq(multiSigWallet.getTransactionsCount(), 1); 
        //checked that transaction is created and accounted for. 
        multiSigWallet.approveTransaction(0); 
        vm.stopPrank();
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 1);
        vm.prank(address(0x456));
        multiSigWallet.revokeApproval(0);
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 0);
        vm.stopPrank();
    }

    ///@notice Test revert on double revoke Approval
    ///@dev This test checks whether an owner can revoke a transaction proposal twice
    function testFail_doubleRevokeApproval() public {
        payable(address(multiSigWallet)).transfer(1000);
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        // Check that the transaction is proposed
        assertEq(multiSigWallet.getTransactionsCount(), 1); 
        multiSigWallet.approveTransaction(0); 
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 1);
        multiSigWallet.revokeApproval(0);
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 0);
        multiSigWallet.revokeApproval(0);
    }

    ///@notice Test revoke Approval for transaction that doesnt exist
    ///@dev This test checks whether the transaction proposal reverts when called with id of a non-existing transaction.
    function testFail_revokeNonExistentApproval() public {
        payable(address(multiSigWallet)).transfer(1000);
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        // Check that the transaction is proposed
        assertEq(multiSigWallet.getTransactionsCount(), 1); 
        multiSigWallet.approveTransaction(0); 
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 1);
        multiSigWallet.revokeApproval(5);
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 0);
    }

    ///@notice Test approve Transaction require "invalid id"
    ///@dev This test checks whether the transaction proposal reverts when called with id of a non-existing transaction.
    function testFail_approveTransactionWrongId() public {
        payable(address(multiSigWallet)).transfer(1000);
        vm.startPrank(address(0x123));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123))); 
        // Check that the transaction is proposed
        assertEq(multiSigWallet.getTransactionsCount(), 1); 
        multiSigWallet.approveTransaction(5); 
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 1);
    }

    ///@notice Test approve Transaction require "transaction already executed"
    ///@dev This test checks whether the transaction proposal reverts when called with id of an exceuted transaction.
    function testFail_approveTransactionExecutedTxn() public {
        payable(address(multiSigWallet)).transfer(1000);
        multiSigWallet.proposeTransaction(1000, payable(address(0x123)));
        multiSigWallet.approveTransaction(0);
        vm.startPrank(address(0x456));
        multiSigWallet.approveTransaction(0);
        assertEq(multiSigWallet.getTransactionByIndex(0).approvals, 2);
        assertEq(multiSigWallet.getTransactionByIndex(0).executed, true);
        vm.stopPrank();
        vm.startPrank(address(0x789));
        multiSigWallet.approveTransaction(0);
    }

    ///@notice Test approve Transaction require "cannot approve a transaction twice"
    //@dev This test checks whether an owner can approve a transaction proposal twice
    function testFail_approveTransactionTwice() public {
        payable(address(multiSigWallet)).transfer(1000);
        multiSigWallet.proposeTransaction(1000, payable(address(0x123)));
        multiSigWallet.approveTransaction(0);
        multiSigWallet.approveTransaction(0);
    }

    // Quaram Change Tests

    ///@notice Test Quorum proposal
    ///@dev This test checks whether the quorum can be proposed
    function test_porposeQuorumChange() public {
        vm.startPrank(address(0x123));
        multiSigWallet.proposeQuorumChange(3);
        assertEq(multiSigWallet.getQuorumChangeProposals().length, 1);
    }

    ///@notice Test Quorum proposal require "not owner"
    ///@dev This test checks whether the quorum can be proposed by a non-owner
    function testFail_porposeQuorumChangeNotOwner() public {
        vm.startPrank(address(0x890));
        multiSigWallet.proposeQuorumChange(3);
    }

    ///@notice Test Quorum proposal require "quorum cannot be greater than number owners"
    ///@dev This test require statement that checks whether the quorum can be larger than the number of owners
    function testFail_proposeQuorumLargerThanOwners() public {
        vm.startPrank(address(0x123));
        multiSigWallet.proposeQuorumChange(4);
    }

    ///@notice Test Quorum proposal require "quorum cannot be less than 2"
    ///@dev This test require statement that checks whether the quorum can be less than 2
    function testFail_proposeQuorumSmallerThanTwo() public {
        vm.startPrank(address(0x123));
        multiSigWallet.proposeQuorumChange(1);
    }

    ///@notice Test quorum Change Approval works
    ///@dev This test checks whether the quorum can be approved
    function test_quorumChangeApproval() public {
        test_porposeQuorumChange(); // proposal of quorum change to 3
        vm.startPrank(address(0x123));
        multiSigWallet.quorumChangeApproval(0);
        assertEq(multiSigWallet.getQuorumChangeProposals().length, 1);
    }

    ///@notice Test quorum change require "cannot approve a quorum change twice"
    function testFail_quorumDoubleChangeApproval() public {
        test_porposeQuorumChange(); // proposal of quorum change to 3
        vm.startPrank(address(0x123));
        multiSigWallet.quorumChangeApproval(0);
        multiSigWallet.quorumChangeApproval(0);
    }

    ///@notice Test that you can revoke quorum change approval
    ///@dev test that you can revoke quorum change approval
    function test_removeQuorumChangeApproval() public {
        test_quorumChangeApproval();
        assertEq(multiSigWallet.getQuorumChangeProposals().length, 1);
        vm.startPrank(address(0x123));
        multiSigWallet.removeQuorumChangeApproval(0);
        MultiSigWallet.QuorumChangeProposal[] memory _list = multiSigWallet.getQuorumChangeProposals();
        assertEq(_list[0].approvals, 0);
    }

    ///@notice Test that you cannot revoke quorum change approval twice
    ///@dev test revoke quorum change approval twice
    function testFail_removeQuorumChangeApprovalTwice() public {
        test_quorumChangeApproval();
        assertEq(multiSigWallet.getQuorumChangeProposals().length, 1);
        vm.startPrank(address(0x123));
        multiSigWallet.removeQuorumChangeApproval(0);
        multiSigWallet.removeQuorumChangeApproval(0);
    }

    ///@notice Test that you cannot revoke quorum change approval after execution
    ///@dev test require statement that checks whether you can revoke quorum change approval after execution
    function testFail_removeQuorumChangeApprovalExecuted() public {
        test_quorumChangeApproval();
        assertEq(multiSigWallet.getQuorumChangeProposals().length, 1);
        vm.startPrank(address(0x123));
        multiSigWallet.removeQuorumChangeApproval(0);
        assertEq(multiSigWallet.getQuorum(), 3);
        vm.startPrank(address(0x456));
        multiSigWallet.removeQuorumChangeApproval(0);
    }

    ///@notice Test that you cannot revoke quorum change approval if you have not approved it
    ///@dev test require statement that checks whether you can revoke quorum change approval if you have not approved it
    function testFail_removeQuorumChangeApprovalNotApproved() public {
        test_quorumChangeApproval();
        assertEq(multiSigWallet.getQuorumChangeProposals().length, 1);
        vm.startPrank(address(0x456));
        multiSigWallet.removeQuorumChangeApproval(0);
    }

    // Owner Proposal Tests

    ///@notice Test new owner function
    ///@dev test that a new owner can be added
    function test_newOwnerProposal() public {
        payable(address(multiSigWallet)).transfer(1000);
        vm.startPrank(address(0x123));
        multiSigWallet.newOwnerProposal(address(0x890));
        assertEq(multiSigWallet.getOwnerProposals().length, 1);
        vm.stopPrank();
    }

    ///@notice test that the owner cannot not propose themself. 
    ///@dev test require statement that checks whether he is not proposing himself
    function testFail_newOwnerProposalSelf() public {
        vm.startPrank(address(0x123));
        multiSigWallet.newOwnerProposal(address(0x123));
        vm.stopPrank();
    }

    ///@notice Test new owner cant propose another owner 
    ///@dev test require statement that checks whether he is not proposing another owner
    function testFail_newOwnerProposalExistingOwner() public {
        vm.startPrank(address(0x123));
        multiSigWallet.newOwnerProposal(address(0x456));
    }

    ///@notice test that only an onwer can propose another owner 
    ///@notice test require statement that only owners can propose aother owner
    function testFail_newOwnerProposalNotOwner() public {
        vm.startPrank(address(0x890));
        multiSigWallet.newOwnerProposal(address(0x835));
    }

    ///@notice test a new owner can be proposed and approved
    ///@dev test that a new owner can be proposed and approved
    function test_newOwnerProposalAndApproval() public {
        test_newOwnerApproval();
        assertEq(multiSigWallet.getOwners().length, 4);
    }

    ///NewOwnerApproval Tests

    ///@notice test that New owner approval function works 
    ///@dev test that new owner can be approved
    function  test_newOwnerApproval() public {
        payable(address(multiSigWallet)).transfer(1000);
        test_newOwnerProposal();
        vm.startPrank(address(0x123));
        multiSigWallet.newOwnerApproval(0);
        vm.startPrank(address(0x456));
        multiSigWallet.newOwnerApproval(0);
        vm.startPrank(address(0x890));
        multiSigWallet.proposeTransaction(1000, payable(address(0x123)));
        MultiSigWallet.Transaction memory txn = multiSigWallet.getTransactionByIndex(0);
        assertEq(txn.amount, 1000);
    }

    ///@notice test that only an owner can approve a new ownerproposal
    ///@dev test require statement that only owners can approve a new owner
    function testFail_newOwnerApprovalNotOwner() public {
        test_newOwnerProposal();
        vm.startPrank(address(0x890));
        multiSigWallet.newOwnerApproval(0);
    }

    ///@notice test require statement that you cant approve a owner proposal twice 
    ///@dev test require statement that you cant approve a owner proposal twice
    function testFail_newOwnerApprovalTwice() public {
        vm.startPrank(address(0x123));
        multiSigWallet.newOwnerProposal(address(0x890));
        multiSigWallet.newOwnerApproval(0);
        multiSigWallet.newOwnerApproval(0);
        vm.stopPrank();
    }

    ///@notice test require statement that only owners can approve a new owner
    ///@dev test require statement that only owners can approve a new owner
    function testFail_approveOwnerProposalNonOwner() public {
        multiSigWallet.newOwnerProposal(address(0x890));
        vm.startPrank(address(0x890));
        multiSigWallet.newOwnerApproval(0);
    }

    // Test Remove Owner Proposal

    ///@notice test that a owner removal can be proposed 
    ///@dev test that a owner removal can be proposed
    function test_proposeOwnerRemoval() public {
        test_newOwnerApproval(); // 0x890 is now an owner
        vm.startPrank(address(0x456));
        multiSigWallet.proposeOwnerRemoval(address(0x890));
        assertEq(multiSigWallet.getOwnerRemovalProposals().length, 1, "Owner removal proposal failed");
    }

    ///@notice test that the ownerRemovalProposal cant be initiated by none owner.
    ///@dev test require statement that you cant remove as none owner 
    function testFail_proposeOwnerRemovalNotOwner() public {
        test_newOwnerApproval(); // 0x890 is now an owner
        vm.startPrank(address(0x321));
        multiSigWallet.proposeOwnerRemoval(address(0x890));
    }

    ///@notice test that removing owner wont drop owner count under quorum
    ///@dev test require statement that you cant remove a owner when it brings you under queorum
    function testFail_proposeOwnerRemovalUnderquorum() public {
        multiSigWallet.proposeOwnerRemoval(address(0x456));
    }

    ///@notice test require statement that you cant remove a owner proposal twice
    ///@dev test require statement that you cant remove a owner proposal twice
    function testFail_proposeOwnerRemovalTwice() public {
        test_newOwnerApproval(); // 0x890 is now an owner
        vm.startPrank(address(0x456));
        multiSigWallet.proposeOwnerRemoval(address(0x890));
        multiSigWallet.proposeOwnerRemoval(address(0x890));
    }

    ///@notice owners can confirm a owner removal proposal
    ///@dev test confirm owner removal proposal and actual removal of owner
    function test_confirmOwnerRemoval() public {
        test_proposeOwnerRemoval(); // 0x890 is now an owner w/ an owner removal proposal of index 0 w/ 0 approvals
        address[] memory list = multiSigWallet.getOwners();
        assertEq(list.length, 4);
        vm.startPrank(address(0x123));
        multiSigWallet.confirmOwnerRemoval(0);
        vm.startPrank(address(0x456));
        multiSigWallet.confirmOwnerRemoval(0);
        list = multiSigWallet.getOwners();
        assertEq(list.length, 3);
    }

    ///@notice test Removes approval or ownwer removal.
    ///@dev test Removes approval of an ownwer removal. 
    function test_removeOwnerRemovalApproval() public {
        test_proposeOwnerRemoval(); // 0x890 is now an owner w/ an owner removal proposal of index 0 w/ 0 approvals
        address[] memory list = multiSigWallet.getOwners();
        assertEq(list.length, 4);
        vm.startPrank(address(0x123));
        multiSigWallet.confirmOwnerRemoval(0);
        multiSigWallet.removeOwnerRemovalApproval(0);
        vm.stopPrank();
        MultiSigWallet.OwnerRemovalProposal[] memory _list = multiSigWallet.getOwnerRemovalProposals();
        assertEq(_list[0].approvals, 0);
    }

    ///@notice test require statement that you cant remove a owner removal proposal twice.
    ///@dev test require statement that you cant decriment approvals of an owner removal proposal twice. 

    //



}