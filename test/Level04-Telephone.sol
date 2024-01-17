// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@levels/Telephone.sol";
import "@levels/TelephoneFactory.sol";
import "@attacks/Level04-Telephone-Attacker.sol";

contract POC is Test {
    Telephone public victim;
    Attacker public attacker;

    address public attacker_eoa;
    TelephoneFactory public factory;

    function setUp() public {
        attacker_eoa = makeAddr("attacker eoa");
        factory = new TelephoneFactory();
        victim = new Telephone();
        vm.prank(attacker_eoa);
        attacker = new Attacker(address(victim));
        vm.label(address(victim), "victim_contract");
        vm.label(address(attacker), "attacker_contract");

        vm.deal(address(victim), 10 ether);
        vm.deal(address(attacker), 1 ether);
    }

    function test_exploit() public {
        console.log(unicode"\n   📚📚 Ethernaut Foundry: basic exploitation\n");
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

        vm.prank(attacker_eoa);
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
