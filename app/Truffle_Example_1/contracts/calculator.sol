// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Calculator {
    bytes public registeredUsers = '[]';
    bytes public medicinesRepo = '[]';
    bytes public PORepo = '[]';

    function getRegisteredUsers() public view returns(string memory){
        return string(registeredUsers);
    }

    function getMedicinesRepo() public view returns(string memory){
        return string(medicinesRepo);
    }

    function getPORepo() public view returns(string memory){
        return string(PORepo);
    }

    function clearMedicinesRepo() public{
        medicinesRepo = '[]';
    }

    function clearPORepo() public{
        PORepo = '[]';
    }

    function addNewUser(string memory arg) public returns(bool){
        // uint a = 2;
        // bytes32 test = "{\r\n  someKey1: 'some value 1',\r\n  someKey2: 'some value 2',\r\n  someKey3: 'some value 3',\r\n}";
        // uint balance[] = [1, 2, 3];
        // uint balance[10];
        // uint balance[] = new uint[](size);,{"key5":"value5","key6":"value6"}
        bytes memory existing;
        if(registeredUsers.length != 2){
		    existing = bytes.concat(slice(registeredUsers, 0, registeredUsers.length-1), ',');
        }
        else{
		    existing = '[';
        }
        bytes memory newUser = bytes(arg);
        registeredUsers = bytes.concat(existing, newUser, ']');
        // emit Event(registeredUsers);
        return true;
        // return string(registeredUsers);
        // return string(bstr);
        // return balance;
    }

    function addNewDrug(string memory arg) public returns(bool){
        bytes memory existing;
        if(medicinesRepo.length != 2){
		    existing = bytes.concat(slice(medicinesRepo, 0, medicinesRepo.length-1), ',');
        }
        else{
		    existing = '[';
        }
        bytes memory newDrug = bytes(arg);
        medicinesRepo = bytes.concat(existing, newDrug, ']');
        return true;
    }

    function addNewPO(string memory arg) public returns(bool){
        bytes memory existing;
        if(PORepo.length != 2){
		    existing = bytes.concat(slice(PORepo, 0, PORepo.length-1), ',');
        }
        else{
		    existing = '[';
        }
        bytes memory newPO = bytes(arg);
        PORepo = bytes.concat(existing, newPO, ']');
        return true;
    }

    function slice(
    bytes memory _bytes,
    uint256 _start,
    uint256 _length
    )
        internal
        pure
        returns (bytes memory)
    {
        require(_length + 31 >= _length, "slice_overflow");
        require(_bytes.length >= _start + _length, "slice_outOfBounds");

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                tempBytes := mload(0x40)
                let lengthmod := and(_length, 31)
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)
                for {
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    mstore(mc, mload(cc))
                }
                mstore(tempBytes, _length)
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            default {
                tempBytes := mload(0x40)
                mstore(tempBytes, 0)
                mstore(0x40, add(tempBytes, 0x20))
            }
        }
        return tempBytes;
    }
}

