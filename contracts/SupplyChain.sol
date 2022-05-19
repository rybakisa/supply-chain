// // SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract SupplyChain {
    
    enum ItemState {Created, Paid, Delivered}
    
    struct Item {
        SupplyChain.ItemState state;
        string name;
        uint priceInWei;
    }
    
    mapping(uint => Item) public items;
    uint itemId;
    
    event ItemStateChanged(uint _itemId, uint _state);

    modifier itemHasState(uint _itemId, SupplyChain.ItemState _state) {
        require(items[_itemId].state == _state, "Item is further in the supply chain");
        _;
    }

    function createItem(string memory _name, uint _priceInWei) public {
        items[itemId].priceInWei = _priceInWei;
        items[itemId].state = ItemState.Created;
        items[itemId].name = _name;

        emit ItemStateChanged(itemId, uint(items[itemId].state));
        
        itemId++;
    }

    function receivePayment(uint _itemId) public payable itemHasState(_itemId, ItemState.Created) {
        require(items[_itemId].priceInWei <= msg.value, "Not fully paid");
        
        items[_itemId].state = ItemState.Paid;
        
        emit ItemStateChanged(_itemId, uint(items[_itemId].state));
    }

    function deliverItem(uint _itemId) public itemHasState(_itemId, ItemState.Paid) {
        items[_itemId].state = ItemState.Delivered;
        
        emit ItemStateChanged(_itemId, uint(items[_itemId].state));
    }
}
