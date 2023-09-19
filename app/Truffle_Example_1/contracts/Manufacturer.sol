// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./User.sol";
import "./Drug.sol";
import "./PurchaseOrder.sol";

contract Manufacturers is Users, Drugs, PurchaseOrders {

    function addDrug(uint32 _id, string memory _name, uint32 _quantity) public hasRegisteredAs(msg.sender, "Manf") { // add drug to the list of drugs produced, along with quantity and drug's id.
        Drug memory drug =  Drug(msg.sender, _id, _name, _quantity);
        uint idx = drugs.length;
        drugs.push(drug);
        string memory sIdx = string(abi.encodePacked(msg.sender, Strings.toString(uint256(_id))));
        // string.concat(abi.encodePacked(msg.sender), Strings.toString(uint256(_id)));
        drugIndex[sIdx] = idx;
    }

    // Note: It is better to store the index to the struct, not a whole struct because it is cheaper.
    function updateQuantity(uint32 _id, uint32 _quantity, uint flag) public hasRegisteredAs(msg.sender, "Manf") {
        require(_quantity >= 0, "Quantity cannot be negative");
        string memory sIdx = string(abi.encodePacked(msg.sender, Strings.toString(uint256(_id))));
        uint idx = drugIndex[sIdx];
        if (flag == 0) {
            drugs[idx].quantity = _quantity; 
        } else if (flag == 1) {
            require(drugs[idx].quantity - _quantity >= 0, "Not enough quantity in stock");
            drugs[idx].quantity = drugs[idx].quantity - _quantity; 
        }
    }

    function acceptPurchaseOrder(PurchaseOrder memory _purchaseOrder) public hasRegisteredAs(msg.sender, "Manf") {
        require(keccak256(abi.encodePacked(_purchaseOrder.status)) == keccak256(abi.encodePacked("PENDING")), "Purchase Order not created yet. First, create Purchase Order");
        _purchaseOrder.status = "ACCEPTED";
        for (uint i = 0; i < _purchaseOrder.drugId.length; i++) {
            updateQuantity(_purchaseOrder.drugId[i], _purchaseOrder.quantity[i], 1); // update quantity at source
            // Drug memory drugsReceived =  Drug(_purchaseOrder.buyer, _purchaseOrder.drugId[i], _name, _quantity);
            // Append these received drugs to array of Drug struct
            appendDrugs(_purchaseOrder.buyer, _purchaseOrder.drugName[i], _purchaseOrder.drugId[i], _purchaseOrder.quantity[i]);
        }
    }

}