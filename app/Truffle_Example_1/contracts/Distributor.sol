// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./Drug.sol";
import "./PurchaseOrder.sol";


contract Distributors is Users, Drugs, PurchaseOrders {    

    function createPurchaseOrder(uint32 _poId, address _seller, string[] memory _drugName, uint32[] memory _drugId, uint32[] memory _quantity) public hasRegisteredAs(msg.sender, "Distr") {
        PurchaseOrder memory purchaseOrder = PurchaseOrder(_poId, msg.sender, _seller, _drugName, _drugId, _quantity, "PENDING");
        purchaseOrders.push(purchaseOrder);
    }
    
     function updateQuantity(uint32 _id, uint32 _quantity, uint flag) public hasRegisteredAs(msg.sender, "Distr") {
        require(_quantity >= 0, "Quantity cannot be negative");
        string memory sIdx = string(abi.encodePacked(msg.sender, Strings.toString(uint256(_id))));
        uint idx = drugIndex[sIdx];
        if (flag == 1) {
            require(drugs[idx].quantity - _quantity >= 0, "Not enough quantity in stock");
            drugs[idx].quantity = drugs[idx].quantity - _quantity; 
        }
    }

        function acceptPurchaseOrder(PurchaseOrder memory _purchaseOrder) public hasRegisteredAs(msg.sender, "Distr") {
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