pragma solidity ^0.8.0;

contract FeeVault {

    uint public totalFees;

    function deposit() public payable {

        totalFees += msg.value;

    }

}
