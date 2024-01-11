// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@levels/Fallback.sol";
import "@attacks/Level00-Fallback-Attacker.sol";

contract POC is Test {
    Fallback public victim;
    Attacker public attacker;

    function setup() public {
        victim = new Fallback();
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
            toEth(address(victim).balance)
        );
        console.log(
            unicode"| => Attacker's balance 👀 %s 👀",
            toEth(address(attacker).balance)
        );
        console.log("--------------------------------------------------------");

        console.log(unicode"\n\t💥💥💥💥 EXPLOITING... 💥💥💥💥\n");

        attacker.exploit();

        // Conditions to fullfill
        assertEq(address(victim).balance, 0);
        assertEq(address(attacker).balance, 11 ether);

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
