// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Utils} from "test/utils/Utils.sol";
import {console2} from "forge-std/console2.sol";

import {CoinFlip} from "src/levels/CoinFlip.sol";
import {CoinFlipFactory} from "src/levels/CoinFlipFactory.sol";
import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

contract TestCoinflip is Test, Utils {
    Ethernaut ethernaut;
    CoinFlip instance;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

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
        CoinFlipFactory factory = new CoinFlipFactory();
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        vm.startPrank(player);
        instance = CoinFlip(
            createLevelInstance(ethernaut, Level(address(factory)), 0)
        );
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                                 TESTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Check the intial state of the level and enviroment.
    function testInit() public {
        vm.prank(player);
        assertFalse(submitLevelInstance(ethernaut, address(instance)));
    }

    /// @notice Test the solution for the level.
    function testSolve() public {
        vm.startPrank(player);

        for (uint256 i = 0; i < 10; i++) {
            uint256 blockValue = uint256(blockhash(block.number - 1));
            bool guess = blockValue / FACTOR == 1;
            instance.flip(guess);

            console2.log("Result: ", instance.consecutiveWins());
            vm.roll(block.number + 1);
        }

        assertTrue(submitLevelInstance(ethernaut, address(instance)));
    }
}
