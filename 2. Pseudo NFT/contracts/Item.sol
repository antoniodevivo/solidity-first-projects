//SPDX-License-Identifier: MIT

pragma solidity 0.6.1;

import "./ItemManager.sol";

//in questo modo si crea un address per l'item
//che può essere pagato in seguito e renderlo indisponibile
//in questo modo si crea una sorta di NFT (visualizzabile solo all'interno di ItemManager però e non in un wallet)

contract Item {
    uint256 public priceInWei;
    uint256 public paidWei;
    uint256 public index;
    ItemManager parentContract;

    constructor(
        ItemManager _parentContract,
        uint256 _priceInWei,
        uint256 _index
    ) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(msg.value == priceInWei, "We don't support partial payments");
        require(paidWei == 0, "Item is already paid!");
        paidWei += msg.value;
        (bool success, ) = address(parentContract).call.value(msg.value)(
            abi.encodeWithSignature("triggerPayment(uint256)", index
        ));
        require(success, "Delivery did not work");
    }

    fallback() external {}
}
