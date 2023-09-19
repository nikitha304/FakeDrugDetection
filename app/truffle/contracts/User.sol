// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Users {

    struct User {
        address addr; // wallet address of manf/distr/retailer
        string role;
        string name;
    }

    User[] public users;

    modifier hasRegisteredAs(address _addr, string memory _role) {
        bool yetToRegister = true;
        for (uint i = 0; i < users.length; i++) {
            if (users[i].addr == _addr && keccak256(abi.encodePacked(users[i].role)) == keccak256(abi.encodePacked(_role))) {
                yetToRegister = false;
                break;
            }
        }
        require(yetToRegister, "Not a valid user");
        _;
    }

    function registerUser(address _addr, string memory _role, string memory _name) external hasRegisteredAs(_addr, _role) returns(uint) {
        users.push(User(_addr, _role, _name));
        return users.length - 1; // id of the user
    }
}