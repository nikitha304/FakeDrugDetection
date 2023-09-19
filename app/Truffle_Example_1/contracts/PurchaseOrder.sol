// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract PurchaseOrders {
    struct PurchaseOrder {
        uint32 poId;
        address buyer;
        address seller;
        string[] drugName;
        uint32[] drugId;
        uint32[] quantity;
        string status;
    }

    PurchaseOrder[] public purchaseOrders;

    // function acceptPurchaseOrder() private {
        
    // }

    // function rejectPurchaseOrder() private {

    // }
}