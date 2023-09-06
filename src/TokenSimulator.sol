// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Token Simulator
/// @author Christian Reyes 
/// @notice Contract that simulates a simple ERC20 token
/// @dev ERC20 token standard: https://eips.ethereum.org/EIPS/eip-20

contract TokenSimulator {

    // Variables

    /// @notice Token name
    string public name = "SimpleERC20";
    /// @notice Token symbol
    string public symbol = "SERC20";
    /// @notice Token decimals
    uint8 public decimals = 18;
    /// @notice Total supply of tokens
    uint256 public totalSupply;

    /// @notice Mapping of token balances
    mapping(address => uint256) public balanceOf;

    /// @notice Mapping of token allowances 
    /// @dev (owner => spender => amount)
    mapping(address => mapping(address => uint256)) public allowance;

    // Events

    /// @notice Emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);
    /// @notice Emitted when token allowance is approved
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    // Functions

    /// @notice Approves a spender to spend a certain amount of tokens
    /// @param _spender Address of the spender
    /// @param _value Amount of tokens to approve
    /// @return success Boolean indicating if the approval was successful
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @notice Transfers tokens from caller of function to another address
    /// @param _to Address to transfer tokens to
    /// @param _value Amount of tokens to transfer
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /// @notice Transfers tokens from one address to another
    /// @param _from Address to transfer tokens from
    /// @param _to Address to transfer tokens to
    /// @param _value Amount of tokens to transfer
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
}
