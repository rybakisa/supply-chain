// // SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract SupplyChain {
    
    enum ItemState {Created, Paid, Delivered}
    
    struct Item {
        SupplyChain.ItemState _state;
        string _identifier;
        uint _priceInWei;
    }
    
    mapping(uint => Item) public items;
    uint itemId;
    
    event ItemStateChanged(uint _itemitemId, uint _state);

    modifier itemHasState(uint _itemId, SupplyChain.ItemState _state) {
        require(items[_itemId]._state == _state, "Item is further in the supply chain");
        _;
    }

    function createItem(string memory _identifier, uint _priceInWei) public {
        items[itemId]._priceInWei = _priceInWei;
        items[itemId]._state = ItemState.Created;
        items[itemId]._identifier = _identifier;

        emit ItemStateChanged(itemId, uint(items[itemId]._state));
        
        itemId++;
    }

    function receivePayment(uint _itemId) public payable itemHasState(_itemId, ItemState.Created) {
        require(items[itemId]._priceInWei <= msg.value, "Not fully paid");
        
        items[_itemId]._state = ItemState.Paid;
        
        emit ItemStateChanged(_itemId, uint(items[_itemId]._state));
    }

    function deliverItem(uint _itemId) public itemHasState(_itemId, ItemState.Paid) {
        items[_itemId]._state = ItemState.Delivered;
        
        emit ItemStateChanged(_itemId, uint(items[_itemId]._state));
    }
}
