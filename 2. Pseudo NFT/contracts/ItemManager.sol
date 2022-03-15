//SPDX-License-Identifier: MIT

pragma solidity 0.6.1;

import "./Item.sol";
import "./Ownable.sol";

contract ItemManager is Ownable {
    enum SupplyChainSteps {
        Created,
        Paid,
        Delivered
    }
    struct S_Item {
        Item _item;
        string _identifier;
        uint256 _priceInWei;
        ItemManager.SupplyChainSteps _step;
    }
    mapping(uint256 => S_Item) public items;
    uint256 itemIndex;
    event SupplyChainStep(uint256 _itemIndex, uint256 _step, address _itemAddress);

    function createItem(string memory _identifier, uint256 _priceInWei) public onlyOwner {
        items[itemIndex]._item = new Item(this, _priceInWei, itemIndex);
        items[itemIndex]._priceInWei = _priceInWei;
        items[itemIndex]._step = SupplyChainSteps.Created;
        items[itemIndex]._identifier = _identifier;
        emit SupplyChainStep(itemIndex, uint256(items[itemIndex]._step), address(items[itemIndex]._item));
        itemIndex++;
    }

    function triggerPayment(uint256 _itemIndex) public payable {
        require(items[itemIndex]._priceInWei <= msg.value, "Not fully paid");
        require(
            items[itemIndex]._step == SupplyChainSteps.Created,
            "Item is further in the supply chain"
        );
        items[_itemIndex]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_itemIndex, uint256(items[_itemIndex]._step), address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint256 _itemIndex) public onlyOwner {
        require(
            items[_itemIndex]._step == SupplyChainSteps.Paid,
            "Item is further in the supply chain"
        );
        items[_itemIndex]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_itemIndex, uint256(items[_itemIndex]._step), address(items[_itemIndex]._item));
    }
}
