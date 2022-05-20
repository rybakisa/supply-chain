// // SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract SupplyChain {
    
    enum ItemState {Created, Paid, Delivered}
    
    struct Item {
        string name;
        uint priceInWei;
        SupplyChain.ItemState state;
    }
    
    Item[] public items;

    mapping (uint => address) public itemToOwner;
    mapping (address => uint) ownerItemsCount;
    
    event ItemStateChanged(uint  _itemId, uint _state);

    modifier itemHasState(uint _itemId, SupplyChain.ItemState _state) {
        require(items[_itemId].state == _state, "Item is further in the supply chain");
        _;
    }

    function createItem(string memory _name, uint _priceInWei) public {
        ItemState newState = ItemState.Created;
        items.push(
            Item(_name, _priceInWei, newState)
        );
        uint itemId = items.length - 1;
        
        itemToOwner[itemId] = msg.sender;
        ownerItemsCount[msg.sender]++;

        emit ItemStateChanged(itemId, uint(items[itemId].state));
    }

    function receivePayment(uint _itemId) public payable itemHasState(_itemId, ItemState.Created) {
        require(items[_itemId].priceInWei <= msg.value, "Not fully paid");
        
        ItemState newState = ItemState.Paid;
        items[_itemId].state = newState;
        
        emit ItemStateChanged(_itemId, uint(newState));
    }

    function deliverItem(uint _itemId) public itemHasState(_itemId, ItemState.Paid) {
        ItemState newState = ItemState.Delivered;
        items[_itemId].state = newState;
        
        emit ItemStateChanged(_itemId, uint(newState));
    }
}
