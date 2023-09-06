// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title MultiSigWallet
/// @author Christian Reyes 
/// @notice This contract implements a basic multi-signature wallet.
/// @dev Multiple owners can propose and approve transactions.

contract MultiSigWallet {

    /// @notice The list of owners who can propose and approve transactions. 
    address[] public owners;

    /// @notice The minimum number of approvals needed to execute a transaction.
    uint public quorum;

    //Structs

    /// @dev Defines a new type for Transaction.
    struct Transaction {
        uint id;            /// Unique ID of the transaction.
        uint amount;        /// Amount of Ether to be transferred.
        address payable to; /// Recipient address of the transaction.
        uint approvals;     /// Number of approvals received.
        bool executed;      /// Whether the transaction has been executed or not.
    }

    /// @dev Defines a new type for owner proposals.
    struct OwnerProposal {
        uint id;
        address newOwner;
        uint approvals;
        bool executed;
}
    
    ///@dev Defines a new type for owner removal proposals.
    struct OwnerRemovalProposal {
        uint id;
        address ownerToRemove;
        uint approvals;
        bool executed;
    }

    ///@dev Defines a new type for quorum change proposals.
    struct QuorumChangeProposal {
        uint id;
        uint newQuorum;
        uint approvals;
        bool executed;
    }

    //State Variables

    ///@notice List of all owner proposals.
    OwnerProposal[] public ownerProposals;

    /// @notice List of all owner removal proposals.
    OwnerRemovalProposal[] public ownerRemovalProposals;
    
    ///@notice List of all quorum change proposals.
    QuorumChangeProposal[] public quorumChangeProposals;

    /// @notice List of all transaction proposals.
    Transaction[] public transactions;


    ///@notice Mapping to keep track of owners.
    mapping(address => bool) public isOwner;

    ///@notice Mapping to keep track of Quorum approvals.
    ///@dev Maps owner address to a mapping of quorum ID to approval status.
    mapping(address => mapping(uint => bool)) public quorumApprovals;

    /// @notice Mapping to keep track of transaction approvals.
    /// @dev Maps owner address to a mapping of transaction ID to approval status.
    mapping(address => mapping(uint => bool)) public approvals;

    ///@notice Mapping to keep track of owner proposals.
    ///@dev Maps owner address to a mapping of ownerApproval by address.
    mapping(address => mapping(uint => bool)) public ownerApprovals;
    
    /// @notice Mapping to keep track of owner proposals.
    /// @dev Maps owner address to a mapping of transaction ID to approval status.
    mapping(address => mapping(uint => bool)) public ownerRemovalApprovals;

    ///@notice Mapping to keep track of owner removal proposals.
    ///@dev Maps owner address to a mapping of ownerRemovalProposals by address.
    mapping(address => bool) public ownerRemovalProposalList;

    //Events

    /// @notice Emitted when a new transaction is proposed.
    event TransactionProposed(uint indexed id, address indexed to, uint amount);

    /// @notice Emitted when a transaction receives an approval.
    event TransactionApprovedBy(uint indexed id, address indexed owner);

    /// @notice Emitted when a transaction is successfully executed.
    event TransactionExecuted(uint indexed id, address indexed to, uint amount);

    /// @notice Emitted when an approval for a transaction is revoked.
    event TransactionRevoked(uint indexed id, address indexed owner);

    /// @notice Emitted when the contract receives Ether.
    event Received(address indexed sender, uint amount);

    /// @notice Emitted when the fallback function is called.
    event FallbackCalled(address indexed sender, uint amount);

    /// @notice Event emitted when an owner removal is proposed.
    event ApproverRemovalProposed(uint indexed id, address indexed owner);

    /// @notice Event emitted when an owner is removed.
    event OwnerRemoved(uint indexed id, address indexed owner);

    /// @notice Event emitted when a new owner is proposed.
    event newOwnerProposed(address indexed _newOwner);

    /// @notice Event emitted when a new owner is approved.
    event newOwnerApproved(uint indexed id, address indexed _newOwner);

    /// @notice Event emitted when an owner removal approval is revoked.
    event OwnerRemovalApprovalRevoked(uint indexed id, address indexed owner);

    ///@notice Event emitted when a new quorum is proposed.
    event newQuorumProposed(uint indexed _newQuorum);

    ///@notice Event emitted when a new quorum is approved.
    event newQuorum(uint indexed _newQuorum);

    //Constructor

    /// @notice Contract constructor to initialize owners and quorum.
    /// @param _owners List of owner addresses.
    /// @param _quorum Minimum number of approvals required.
    constructor(address[] memory _owners, uint _quorum)  {
        owners = _owners;
            // Loop to add each owners into a mapping if you have one (Optional)
        for(uint i = 0; i < _owners.length; i++) {
           isOwner[_owners[i]] = true;
        }
        quorum = _quorum;
    }

    //Reciever & Fallback function

    /// @notice Receive function to handle incoming Ether transfers.
    /// @dev This function is called when Ether is sent to the contract with no data.
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    /// @notice Fallback function to handle unexpected function calls or additional data.
    /// @dev This function is called when no other function matches the called function signature,
    /// or when no data is supplied and the receive function is not present.
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value);
    }

    //Modifiers

    /// @dev Modifier to restrict access to owners only.
    modifier onlyOwners() {
        bool allowed = false;
        for(uint i = 0; i < owners.length; i++) {
            if(owners[i] == msg.sender) { //If the sender is an owner, allow the function to be executed
                allowed = true;
            }
        }
        require(allowed == true, 'only owner allowed');
        _;
    }

    /// @dev Modifier to check if an owner exists & restrict more gas efficently.
    modifier ownerExists(address owner) {
        if (!isOwner[owner])
            revert('owner does not exist');
        _;
    }

    //Get Functions

    /// @notice Returns the list of owners.
    /// @return List of owner addresses.
    function getOwners() external view returns(address[] memory) {
        return owners;
    }

    /// @notice Returns quoreum
    /// @return Quorum
    function getQuorum() external view returns(uint) {
        return quorum;
    }

    /// @notice Returns the list of transaction proposals.
    /// @return List of Transaction structs.
    function getTransactions() external view returns(Transaction[] memory) {
        return transactions;
    }

    /// @notice Returns a transaction by ID.
    /// @param id ID of the transaction to be returned.
    function getTransactionByIndex(uint id) external view returns(Transaction memory) {
        require(id < transactions.length, "Index out of bounds");
        return transactions[id];
    }

    /// @notice Returns the number of transactions.
    /// @return The length of the transactions array.
    function getTransactionsCount() public view returns (uint256) {
        return transactions.length;
    }

    /// @notice Returns the balance of the contract.
    /// @return Balance of the contract.
    function getBalance() external view returns(uint)  {
        return address(this).balance;
    }

    ///@notice Returns the list of owner removal proposals.
    //@dev Returns the list of owner removal proposals.
    function getOwnerRemovalProposals() external view returns(OwnerRemovalProposal[] memory) {
        return ownerRemovalProposals;
    }

    ///@notice Returns the list of owner proposals.
    ///@dev Returns the list of owner proposals.
    function getOwnerProposals() external view returns(OwnerProposal[] memory) {
        return ownerProposals;
    }

    ///@notice Returns the list of quorum change proposals.
    ///@dev Returns the list of quorum change proposals.
    function getQuorumChangeProposals() external view returns(QuorumChangeProposal[] memory) {
        return quorumChangeProposals;
    }

    //Transfers Functions

    /// @notice Proposes a new transaction.
    /// @dev Only an owner can propose a transaction.
    /// @param _amount Amount of Ether to be transferred.
    /// @param _to Recipient address.
    function proposeTransaction(uint _amount, address payable _to) external ownerExists(msg.sender) {
        require(_amount <= address(this).balance, 'not enough funds');
        transactions.push(Transaction({
            id: transactions.length,
            amount: _amount,
            to: _to,
            approvals: 0,
            executed: false
        }));
        emit TransactionProposed(transactions.length - 1, _to, _amount);
    }

    /// @notice Revokes an approval for a transaction proposal.
    /// @dev Only an owner can revoke an approval.
    /// @param id ID of the transfer for which to revoke approval.
    function revokeApproval(uint id) external ownerExists(msg.sender) {
        require(transactions[id].executed == false, 'transaction has already been sent');
        // owner cannot revoke approval if they have not yet approved the transaction
        require(approvals[msg.sender][id] == true, 'Already revoked approval or never gave Approval for this transfe');
    
      approvals[msg.sender][id] = false; // Revoke approval
      transactions[id].approvals--; // Decrement the number of approvals for this transfer

      emit TransactionRevoked(id, msg.sender);
    }

    /// @notice Approves a transaction proposal.
    /// @dev Only an owner can approve a transaction.
    /// @param id ID of the transfer to be approved.
    function approveTransaction(uint id) external ownerExists(msg.sender) {
        require(id < transactions.length, 'invalid transaction id');
        require(transactions[id].executed == false, 'transaction has already been executed');
        require(approvals[msg.sender][id] == false, 'cannot approve transfer twice');
        
        approvals[msg.sender][id] = true; //Nested mapping to keep track of approvals
        transactions[id].approvals++;     //Adding one more approval from the owners

        emit TransactionApprovedBy(id, msg.sender);
        
        //Transaction execution

        if(transactions[id].approvals >= quorum) { //If the number of approvals is greater than the quorum execute the transaction
            transactions[id].executed = true;
            address payable to = transactions[id].to;
            uint amount = transactions[id].amount;
            to.transfer(amount);  //Transfer the amount to the recipient
            emit TransactionExecuted(id, to, amount);
        }
    }

    //Admin functions

    /// @notice create new quorum proposal.
    /// @dev Only an owner can change the quorum.
    /// @param  _newQuorum New quorum to be proposed.
    function proposeQuorumChange(uint _newQuorum) external onlyOwners() {
        require(_newQuorum <= owners.length, 'quorum cannot be greater than the number of owners');
        require(_newQuorum >= 2, 'quorum must be greater than 2');
        quorumChangeProposals.push(QuorumChangeProposal({
            id: quorumChangeProposals.length,
            newQuorum: _newQuorum,
            approvals: 0,
            executed: false
        }));
        emit newQuorumProposed(_newQuorum);
    }

    /// @notice Approves a new quorum.
    /// @dev Only an existing owner can approve a new quorum.
    /// @param id ID of the new quorum proposal.
    function quorumChangeApproval(uint id) external ownerExists(msg.sender) {
        require(quorumApprovals[msg.sender][id] == false, "cannot approve quorum change twice");

        quorumChangeProposals[id].approvals++;
        quorumApprovals[msg.sender][id] = true;

        if(quorumChangeProposals[id].approvals >= quorum) {
            quorumChangeProposals[id].executed = true;
            quorum = quorumChangeProposals[id].newQuorum;

            emit newQuorum(quorumChangeProposals[id].newQuorum);
        }
    }

    /// @notice Removes Approval of a quorum change
    /// @dev This function should only be callable by an existing owner.
    /// @param id The unique identifier of the quorum change to be approved.
    function removeQuorumChangeApproval(uint id) external ownerExists(msg.sender) {
        require(quorumChangeProposals[id].executed == false, "Quorum has already been executed");
        require(quorumApprovals[msg.sender][id] == true, "Cannot remove quorum approval twice or without approving first");

        quorumApprovals[msg.sender][id] = false;
        quorumChangeProposals[id].approvals--;

        emit newQuorumProposed(quorumChangeProposals[id].newQuorum);
    }

    /// @notice Proposes a new owner.
    /// @dev Only an existing owner can propose a new owner.
    /// @param _newOwner Address of the new owner.
    function newOwnerProposal(address _newOwner) external ownerExists(msg.sender) {
        require(!isOwner[_newOwner], "Address is already an owner");
        ownerProposals.push(OwnerProposal({
            id: ownerProposals.length,
            newOwner: _newOwner,
            approvals: 0,
            executed: false
        }));
        emit newOwnerProposed(_newOwner);
    }

    /// @notice Approves a new owner.
    /// @dev Only an existing owner can approve a new owner.
    /// @param id ID of the new owner proposal.
    function newOwnerApproval(uint id) external ownerExists(msg.sender) {
        //Change d so that you can still approve of a proposal that an owner has already approved for immutable record keeping purposes
        // require that owner hasnt approved twice 
        require(ownerApprovals[msg.sender][id] == false, "cannot approve owner twice");

        ownerApprovals[msg.sender][id] = true;
        ownerProposals[id].approvals++;

        if(ownerProposals[id].approvals >= quorum) {
            ownerProposals[id].executed = true;
            isOwner[ownerProposals[id].newOwner] = true;
            owners.push(ownerProposals[id].newOwner);

            emit newOwnerApproved(id, ownerProposals[id].newOwner);
        }
    }

    /// @notice Proposes the removal of an owner.
    /// @dev This function should only be callable by an existing owner and the owner to be removed must also exist.
    /// @param _ownerToRemove The address of the owner to be removed.
    function proposeOwnerRemoval(address _ownerToRemove) external ownerExists(msg.sender) ownerExists(_ownerToRemove){
        require(owners.length - 1 >= quorum, "Cannot remove the owner if the quorum is not met");
        require(isOwner[_ownerToRemove] == true, "Address is not an owner");
        //require statement that checks if this owner has already been proposed for removal
        require(ownerRemovalProposalList[_ownerToRemove] == false, "Owner has already been proposed for removal");
        ownerRemovalProposalList[_ownerToRemove] = true;
        ownerRemovalProposals.push(OwnerRemovalProposal({
            id: ownerRemovalProposals.length,
            ownerToRemove: _ownerToRemove,
            approvals: 0,
            executed: false
        }));
        emit ApproverRemovalProposed(ownerRemovalProposals.length - 1, _ownerToRemove);
    }

    /// @notice Approves the removal of an owner.
    /// @dev This function should only be callable by an existing owner.
    /// @param id The unique identifier of the removal to be approved.
    function confirmOwnerRemoval(uint id) external ownerExists(msg.sender) {
        require(ownerRemovalProposals[id].executed == false, "Removal has already been executed");
        require(ownerRemovalApprovals[msg.sender][id] == false, "Cannot approve removal twice");
        require(owners.length - 1 >= quorum, "Cannot remove the owner if the quorum is not met");

        ownerRemovalApprovals[msg.sender][id] = true;
        ownerRemovalProposals[id].approvals++;

        if(ownerRemovalProposals[id].approvals >= quorum) {
            ownerRemovalProposals[id].executed = true;
            // Logic to remove the owner
            isOwner[ownerRemovalProposals[id].ownerToRemove] = false;// remove the owner from the mapping
            address ownerToRemove = ownerRemovalProposals[id].ownerToRemove;
            uint index = 0;
            bool found = false;
            for(uint i = 0; i < owners.length; i++) {
                if(owners[i] == ownerToRemove) {
                    index = i;
                    found = true;
                    break;
                }
            }

        // Revert if the owner is not found
        require(found, "Approver not found");

        // Remove the owner by swapping it with the last element and then popping from the array
            owners[index] = owners[owners.length - 1];
             owners.pop();

            emit OwnerRemoved(id, ownerRemovalProposals[id].ownerToRemove);
        }
    }

    ///@notice Removes Approval of an owner removal 
    ///@dev This function should only be callable by an existing owner. 
    function removeOwnerRemovalApproval(uint id) external ownerExists(msg.sender) {
        require(ownerRemovalApprovals[msg.sender][id] == true, "Cannot remove removal approval twice");

        ownerRemovalApprovals[msg.sender][id] = false;
        ownerRemovalProposals[id].approvals--;

        emit OwnerRemovalApprovalRevoked(id, msg.sender);
    }

}
