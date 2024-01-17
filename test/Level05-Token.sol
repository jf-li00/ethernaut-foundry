// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@levels/Token.sol";
import "@levels/TokenFactory.sol";
import "@attacks/Level05-Token-Attacker.sol";

contract POC is Test {
    Token public victim;
    Attacker public attacker;

    TokenFactory public factory;
    uint start_block = 10;

    function setUp() public {
        factory = new TokenFactory();
        address victim_addr = factory.createInstance(address(attacker));
        victim = Token(victim_addr);
        attacker = new Attacker(address(victim));

        vm.label(address(victim), "victim_contract");
        vm.label(address(attacker), "attacker_contract");

        vm.deal(address(victim), 10 ether);
        vm.deal(address(attacker), 1 ether);
    }

    function test_exploit() public {
        console.log(
            unicode"\n   📚📚 All things reentrancy: basic exploitation\n"
        );
        console.log("--------------------------------------------------------");
        console.log(
            unicode"| => Victim's balance 🙂 %s 🙂",
            toEth(victim.balanceOf(address(victim)))
        );
        console.log(
            unicode"| => Victim's owner is still not the attacker, waiting for the exploitation begin....."
        );
        console.log(
            unicode"| => Attacker's balance 👀 %s 👀",
            toEth(victim.balanceOf(address(attacker)))
        );

        console.log("--------------------------------------------------------");

        console.log(unicode"\n\t💥💥💥💥 EXPLOITING... 💥💥💥💥\n");

        attacker.exploit();

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
            toEth(victim.balanceOf(address(victim)))
        );
        console.log(
            unicode"| => Attacker's balance 💯 %s 💯",
            toEth(victim.balanceOf(address(attacker)))
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
