// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SimpleMultiSigWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;
    
    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        mapping(address => bool) confirmations;
        uint confirmCount;
    }
    
    mapping(uint => Transaction) public transactions;
    uint public transactionCount;
    
    event Deposit(address indexed sender, uint value);
    event Submission(uint indexed transactionId);
    event Confirmation(address indexed sender, uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);
    
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }
    
    modifier txExists(uint _txId) {
        require(_txId < transactionCount, "Transaction does not exist");
        _;
    }
    
    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "Already executed");
        _;
    }
    
    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0 && _required > 0 && _required <= _owners.length, "Invalid parameters");
        for (uint i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0) && !isOwner[_owners[i]], "Invalid owner");
            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }
        required = _required;
    }
    
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    
    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner returns (uint) {
        uint txId = transactionCount++;
        Transaction storage txn = transactions[txId];
        txn.to = _to;
        txn.value = _value;
        txn.data = _data;
        emit Submission(txId);
        confirmTransaction(txId);
        return txId;
    }
    
    function confirmTransaction(uint _txId) public onlyOwner txExists(_txId) notExecuted(_txId) {
        Transaction storage txn = transactions[_txId];
        require(!txn.confirmations[msg.sender], "Already confirmed");
        txn.confirmations[msg.sender] = true;
        txn.confirmCount++;
        emit Confirmation(msg.sender, _txId);
        executeTransaction(_txId);
    }
    
    function executeTransaction(uint _txId) public txExists(_txId) notExecuted(_txId) {
        Transaction storage txn = transactions[_txId];
        if (txn.confirmCount >= required) {
            txn.executed = true;
            (bool success, ) = txn.to.call{value: txn.value}(txn.data);
            if (success) emit Execution(_txId);
            else {
                emit ExecutionFailure(_txId);
                txn.executed = false;
            }
        }
    }
}
