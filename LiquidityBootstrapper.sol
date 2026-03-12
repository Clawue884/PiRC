pragma solidity ^0.8.0;

interface LiquidityController {

    function addLiquidity(uint amount) external;

}

contract LiquidityBootstrapper {

    LiquidityController public controller;

    constructor(address _controller){

        controller = LiquidityController(_controller);

    }

    function bootstrap(uint amount) public {

        controller.addLiquidity(amount);

    }

}
