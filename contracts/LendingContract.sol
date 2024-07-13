// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract LendingContract {
    address public owner;
    uint256 private balance;

    struct Contract {
        uint256 id;
        address customer;
        uint256 amount;
        uint256 timeStarted; // when was the start of the lending
        uint256 timeEnded;   // deadline for the contract
    }

    Contract[] public contracts;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    event ContractCreated(uint256 indexed id, address indexed customer, uint256 amount, uint256 timeStarted, uint256 timeEnded);
    event Deposit(uint256 amount);
    event Withdrawal(uint256 amount);

    constructor() {
        owner = msg.sender;
        balance = 0;
    }

    function createContract(address _customer, uint256 _amount, uint256 _timeEnded) public onlyOwner {
        require(_amount <= balance, "Insufficient balance");
        require(_timeEnded > block.timestamp, "End time must be in the future");

        uint256 newContractId = contracts.length;
        Contract memory newContract = Contract({
            id: newContractId,
            customer: _customer,
            amount: _amount,
            timeStarted: block.timestamp,
            timeEnded: _timeEnded
        });
        contracts.push(newContract);
        balance -= _amount;

        emit ContractCreated(newContractId, _customer, _amount, block.timestamp, _timeEnded);
    }

    function getContract(uint256 _contractId) public view returns (Contract memory) {
        require(_contractId < contracts.length, "Contract does not exist");
        return contracts[_contractId];
    }

    function deposit(uint256 _amount) public onlyOwner {
        balance += _amount;
        emit Deposit(_amount);
    }

    function withdraw(uint256 _amount) public onlyOwner {
        require(_amount <= balance, "Insufficient balance");
        balance -= _amount;
        emit Withdrawal(_amount);
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }
}
