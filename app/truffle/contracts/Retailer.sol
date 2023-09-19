// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./Drug.sol";
import "./PurchaseOrder.sol";

contract Retailers is Users, Drugs, PurchaseOrders {    

    function createPurchaseOrder(uint32 _poId, address _buyer, string[] memory _drugName, uint32[] memory _drugId, uint32[] memory _quantity) public hasRegisteredAs(msg.sender, "Retail") {
        PurchaseOrder memory purchaseOrder = PurchaseOrder(_poId, msg.sender, _buyer, _drugName, _drugId, _quantity, "PENDING");
        purchaseOrders.push(purchaseOrder);
    }

}
    

    

