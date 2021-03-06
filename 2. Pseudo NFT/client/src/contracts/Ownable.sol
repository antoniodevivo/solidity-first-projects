//SPDX-License-Identifier: MIT

//for not import all OpenZeppelin contract

pragma solidity 0.6.1;

contract Ownable {
    address public _owner;

    constructor() public {
        _owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return (msg.sender == _owner);
    }
}
