// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSend {

    function sendEther(address payable[] memory recipients) public payable {

        uint256 totalRecipients = recipients.length;

        require(totalRecipients > 0, "No recipients provided");
        require(msg.value > 0, "Send some Ether");

        uint256 amountPerPerson = msg.value / totalRecipients;

        for (uint256 i = 0; i < totalRecipients; i++) {

            (bool success, ) = recipients[i].call{value: amountPerPerson}("");

            require(success, "Transfer failed");
        }
    }
}
