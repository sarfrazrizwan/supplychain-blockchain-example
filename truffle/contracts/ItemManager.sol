//SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "./Item.sol";

contract ItemManager {
    event SupplyChainProgress(
        uint _index,
        uint _price,
        uint8 _state,
        address _itemAddress
    );

    enum ItemState {
        CREATED,
        PAID,
        DELIVERED
    }
    uint index;
    struct S_Item {
        Item _item;
        string _identifier;
        uint _price;
        ItemState _state;
    }

    mapping(uint => S_Item) public items;

    function createItem(string memory _identifier, uint _price) public {
        Item item = new Item(this, _price, index);

        items[index]._item = item;
        items[index]._identifier = _identifier;
        items[index]._price = _price;
        items[index]._state = ItemState.CREATED;

        emit SupplyChainProgress(
            index,
            _price,
            uint8(ItemState.CREATED),
            address(item)
        );

        index++;
    }

    function triggerPayment(uint _index) public payable {
        require(items[_index]._price == msg.value, "Only full payment allowed");
        require(
            items[_index]._state == ItemState.CREATED,
            "Payment not allowed at this state"
        );

        items[_index]._state = ItemState.PAID;

        emit SupplyChainProgress(
            _index,
            items[_index]._price,
            uint8(items[_index]._state),
            items[_index]._item.itemManager.address
        );
    }

    function triggerDelivery(uint _index) public {
        require(
            items[_index]._state == ItemState.PAID,
            "Only paid item can be marked as delivered"
        );

        items[_index]._state = ItemState.DELIVERED;

        emit SupplyChainProgress(
            _index,
            items[_index]._price,
            uint8(items[_index]._state),
            items[_index]._item.itemManager.address
        );
    }
}
