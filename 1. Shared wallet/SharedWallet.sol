//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract SharedWallet {

    //global variables
    mapping(address => uint) equity;

    uint private totalSharedAmount;

    address payable owner;

    //events
    event AmountChanged(string message, address _address, uint _amount);
    event WithdrawalMessage(string message, uint _amount);

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {

    }

    //modifiers
    modifier mustBeOwnerHandler {
        require(msg.sender == owner, "You are not enabled because you are not the owner");
        _;
    }

    modifier mustBeNotOwnerHandler {
        require(msg.sender != owner, "You are not enabled because you are the owner");
        _;
    }

    

    //functions
    function changeAmountSubWallets(address _address, uint _amount) external mustBeOwnerHandler {

        uint t_total = totalSharedAmount - equity[_address];
        equity[_address] = 0;
        
        if(t_total + _amount > address(this).balance)
            equity[_address] = address(this).balance - t_total;
        else
            equity[_address] = _amount;

        totalSharedAmount = t_total + equity[_address];

        //invia un messaggio di risposta
        emit AmountChanged("The new amount is:", _address, _amount);
    }

    function withdrawalOwner(uint _amount) external mustBeOwnerHandler {
        require(address(this).balance >= _amount, "There are not enough funds in the wallet");

        address payable to = payable(msg.sender);
        to.transfer(_amount * (1 ether));

        emit WithdrawalMessage("You withdrawn: ", _amount);
    }

    function withdrawalGuest(uint _amount) external mustBeNotOwnerHandler {
        require(equity[msg.sender] >= _amount, "You do not have the option to withdraw the amount of money you have requested");
        require(address(this).balance > _amount, "There are no funds in the wallet");
        
        address payable to = payable(msg.sender);
        to.transfer(_amount * (1 ether));
        equity[msg.sender] -= _amount;

        emit WithdrawalMessage("You withdrawn: ", _amount);
    }

    function seeYourBalance() external view mustBeNotOwnerHandler returns (uint) {
        return equity[msg.sender];
    }

    function seeContractBalance() external view mustBeOwnerHandler returns (uint) {
        return address(this).balance;
    }



}