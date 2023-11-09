//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "./ItemManager.sol";

contract Item {
    uint public price;
    uint public index;
    // uint public pricePaid;
    ItemManager public itemManager;

    event LogReturnData(bytes returnData);

    constructor(ItemManager _itemManager, uint _price, uint _index) {
        price = _price;
        index = _index;
        itemManager = _itemManager;
    }

    function getAddress() public view returns (address) {
        return address(itemManager);
    }

    receive() external payable {
        // require(pricePaid == 0, "Already paid.");
        require(price == msg.value, "Only allowed full payment.");

        (bool success, ) = address(itemManager).call{value: msg.value}(
            abi.encodeWithSignature("triggerPayment(uint256)", index)
        );

        require(success, "Transsaction didn't went good");
    }

    fallback() external {}
}
