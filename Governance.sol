pragma solidity ^0.8.0;

contract Governance {

    uint public externalLiquidityWeight = 1e7;

    function updateWeight(uint newWeight) public {

        externalLiquidityWeight = newWeight;

    }

}
