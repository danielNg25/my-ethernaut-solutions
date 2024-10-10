// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Utils} from "test/utils/Utils.sol";

import {GatekeeperOne} from "src/levels/GatekeeperOne.sol";
import {GatekeeperOneFactory} from "src/levels/GatekeeperOneFactory.sol";
import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";
import {GateKeeperOneAttack} from "../../src/attacks/GateKeeperOneAttack.sol";

contract TestGatekeeperOne is Test, Utils {
    Ethernaut ethernaut;
    GatekeeperOne instance;

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
        GatekeeperOneFactory factory = new GatekeeperOneFactory();
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        vm.startPrank(player);
        instance = GatekeeperOne(
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
        vm.deal(player, 1 ether);
        vm.startPrank(player, player);

        GateKeeperOneAttack attack = new GateKeeperOneAttack(address(instance));
        attack.attack();

        assertTrue(submitLevelInstance(ethernaut, address(instance)));
    }
}
