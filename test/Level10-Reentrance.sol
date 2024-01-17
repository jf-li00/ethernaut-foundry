// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@levels/Reentrance.sol";
import "@levels/ReentranceFactory.sol";
import "@attacks/Level10-Reentrance-Attacker.sol";

contract POC is Test {
    Reentrance public victim;
    Attacker public attacker;

    ReentranceFactory public factory;

    function setUp() public {
        factory = new ReentranceFactory();
        address victim_addr = factory.createInstance{value: 1 ether}(
            address(attacker)
        );
        victim = Reentrance(payable(victim_addr));
        attacker = new Attacker(address(victim));

        vm.label(address(victim), "victim_contract");
        vm.label(address(attacker), "attacker_contract");

        // The balance of victim can not be devide by the balance of attacker,
        // which brings a bit difficulties to the exploitation.
        vm.deal(address(victim), 10.5 ether);
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
    }

    function toEth(uint256 _wei) internal pure returns (string memory) {
        string memory eth = vm.toString(_wei / 1 ether);
        string memory decs = vm.toString(_wei % 1 ether);

        string memory result = string.concat(string.concat(eth, "."), decs);

        return result;
    }
}
