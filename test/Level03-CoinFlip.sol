// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@levels/CoinFlip.sol";
import "@levels/CoinFlipFactory.sol";
import "@attacks/Level03-CoinFlip-Attacker.sol";

contract POC is Test {
    CoinFlip public victim;
    Attacker public attacker;

    CoinFlipFactory public factory;
    uint start_block = 10;
    uint success_sequence_length = 10;

    function setUp() public {
        factory = new CoinFlipFactory();
        victim = new CoinFlip();
        attacker = new Attacker(address(victim));
        vm.label(address(victim), "victim_contract");
        vm.label(address(attacker), "attacker_contract");

        vm.deal(address(victim), 10 ether);
        vm.deal(address(attacker), 1 ether);
        vm.roll(start_block);
    }

    function test_exploit() public {
        console.log(
            unicode"\n   📚📚 All things reentrancy: basic exploitation\n"
        );
        console.log("--------------------------------------------------------");
        console.log(
            unicode"| => Victim's balance 🙂 %s 🙂",
            toEth(address(victim).balance)
        );
        console.log(
            unicode"| => Victim's owner is still not the attacker, waiting for the exploitation begin....."
        );
        console.log(
            unicode"| => Attacker's balance 👀 %s 👀",
            toEth(address(attacker).balance)
        );

        console.log("--------------------------------------------------------");

        console.log(unicode"\n\t💥💥💥💥 EXPLOITING... 💥💥💥💥\n");

        for (uint i = 0; i < success_sequence_length; i++) {
            attacker.exploit();
            vm.roll(start_block + i + 1);
        }

        // Conditions to fullfill
        assert(
            factory.validateInstance(
                payable(address(victim)),
                address(attacker)
            )
        );

        console.log("--------------------------------------------------------");
        console.log(
            unicode"| => Victim's balance ☠  %s ☠",
            toEth(address(victim).balance)
        );
        console.log(
            unicode"| => Attacker's balance 💯 %s 💯",
            toEth(address(attacker).balance)
        );
        console.log("--------------------------------------------------------");
    }

    function toEth(uint256 _wei) internal pure returns (string memory) {
        string memory eth = vm.toString(_wei / 1 ether);
        string memory decs = vm.toString(_wei % 1 ether);

        string memory result = string.concat(string.concat(eth, "."), decs);

        return result;
    }
}
