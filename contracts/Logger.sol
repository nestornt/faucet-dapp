// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// It's a way for designer to say that
// "any child of the abstract contract has to implmenet speicifed methods"
// abstract contract usually provide function definitions (can also contain implementations)

abstract contract Logger {

  uint public testNum;

  constructor() {
    testNum = 1000;
  }
  
  // function def to be overrided 
  function emitLog() public pure virtual returns(bytes32);

  // internal allows this contract to be called within it only or from an inherited contract 
  function test3() internal pure returns(uint) {
    return 100;
  }
  
  function test4() external pure returns(uint) {
    test3();
    return 10;
  }
}