// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Drugs {
    struct Drug {
        address holdingEntity;
        uint32 id;
        string name;
        uint32 quantity;
    }

    // struct Key {
    //     address owner;
    //     uint32 id;
    // }

    Drug[] public drugs;

    mapping(string => uint) public drugIndex;

    // function updateListOfDrugs(uint32 _serialNumber, string memory _name, uint32 _quantity, address _manufacturer) internal returns(Drug[] storage){
    //     drugs.push(Drug(_serialNumber, _name, _quantity, _manufacturer));
    //     return drugs;
    // }

    function getListOfDrugs() public view returns(Drug[] memory) { // just to read the list of drugs, so used 'view'
        Drug[] memory drugsAtAnEntity = new Drug[](drugs.length);
        for (uint i = 0 ; i < drugs.length; i++) {
                Drug storage drug = drugs[i];
                drugsAtAnEntity[i] = drug;
        }
        return drugsAtAnEntity;
    }

    function appendDrugs(address _owner, string memory _name, uint32 _id, uint32 _quantity) internal {
        string memory sIdx = string(abi.encodePacked(_owner, Strings.toString(uint256(_id))));
        if (drugIndex[sIdx] == 0) { // if there is no value present for this key
            Drug memory drug =  Drug(_owner, _id, _name, _quantity);
            uint idx = drugs.length;
            drugs.push(drug);
            // string.concat(abi.encodePacked(msg.sender), Strings.toString(uint256(_id)));
            drugIndex[sIdx] = idx;
        } else {
            drugs[drugIndex[sIdx]].quantity = drugs[drugIndex[sIdx]].quantity + _quantity; 
        }
    }
}