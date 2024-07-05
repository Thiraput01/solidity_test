//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Calculator{

    uint256 res = 0;

    function add( uint256 num ) internal  {
        res += num;
    }

    function subtract( uint256 num ) public {
        res -= num;
    }

    function multiply( uint256 num ) public {
        res *= num;
    }

    function get() public view returns(uint256) {
        return res;
    }
}