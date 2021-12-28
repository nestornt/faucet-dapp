// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Owned.sol";
import "./Logger.sol";
import "./IFaucet.sol";

contract Faucet is Owned, Logger, IFaucet {

  uint public numOfFunders;
  // mappings won´t show its values in the view, but we could take numOfFunders as a ref to see the num of funders
  // in a mapping you have to set the type of the key and the type of the value
  mapping(address => bool) private funders;
  mapping(uint => address) private lutFunders; // lut -> lookup table

  modifier limitWithdraw(uint withdrawAmount) {
    // Set the maximun withdraw amount of 0.1 ether, spefifying it in Wei
    require(
      withdrawAmount <= 100000000000000000,
      "Cannot withdraw more than 0.1 ether"
    );
    // If the condition is met, the function body of a function calling this modifier will get executed
    _;
  }

  receive() external payable {}

  // overrided function inherited from Logger contract, it forces us to do it if we are inheriting an abstract contract 
  function emitLog() public override pure returns(bytes32) {
    return "Helloo";
  }

  function transferOwnership(address newOwner) external onlyOwner {
    owner = newOwner;
  }

  function addFunds() external payable {
    // Assign the address of the sender
    address funder = msg.sender;
    // If the new address is not in funders mapping (To prevent duplications)
    if (!funders[funder]) {
      // It will get incremented once the function ends its execution, because we are asigning it to
      // a variable definition, not just incrementing the already defined variable numOfFunders
      uint index = numOfFunders++;
      funders[funder] = true;
      lutFunders[index] = funder;
    }
  }

  // Just onlyOwner (our admin address) can call this function
  function test1() external onlyOwner {
    // some managing stuff that only admin should have access to
  }

  function test2() external onlyOwner {
    // some managing stuff that only admin should have access to
  }

  function withdraw(uint withdrawAmount) external limitWithdraw(withdrawAmount) {
    payable(msg.sender).transfer(withdrawAmount);
  }

  function getAllFunders() external view returns(address[] memory) {
    // It will create an array of numOfFunders length
    address[] memory _funders = new address[](numOfFunders);

    for (uint i = 0; i < numOfFunders; i++) {
      _funders[i] = lutFunders[i];
    }

    return _funders;
  }

  // It will return the address of the specified funder
  function getFounderAtIndex(uint8 index) external view returns(address) {
    return lutFunders[index];
  }

}

// TESTING COMMANDS

// instance = await Faucet.deployed()

// instance.addFunds({from: accounts[0], value: "2000000000000000000"}) | 2 ether
// instance.addFunds({from: accounts[1], value: "1000000000000000000"}) | 1 ether

// instance.withdraw("900000000000000000", {from: accounts[1]})

// instance.getFunderAtIndex(0)
// instance.getAllFunders()

// See the owner admin address -> const owner = await instance.owner.call()

// result = await instance.test3()
// result.toString()