// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Storage {

  // Maximum size in EVM storage per slot is 256 bits or 32 bytes

  mapping(uint => uint) public aa; // slot 0
  mapping(address => uint) public bb; // slot 1
  // keccak256(key . slot) | We need to hash together the key and the slot to
  // see the mapping values at the storage

  uint[] public cc; // slot 2
  // keccak256(slot) + index of the item
  // We keep the size of the array only at an array slot position

  uint8 public a = 7;  // 1 byte
  uint16 public b = 10;  // 2 bytes
  address public c = 0xfcFBfE3f85E72b06443e0C856bb40b95488E06b5; // 20 bytes
  bool d = true; // 1 byte
  uint64 public e = 15; // 8 bytes
  // 32 bytes (The maximum size of a slot), all values will be stored at slot 3 
  // slot 3 => 0x0f01fcfbfe3f85e72b06443e0c856bb40b95488e06b5000a07
  // 0x e -> 0f | d -> 01 | c -> fcFBfE3f85E72b06443e0C856bb40b95488E06b5 | b -> 000a | a -> 07 

  uint256 public f = 200; // 32 bytes -> slot 4
  uint8 public g = 40;  // 1 byte -> slot 5
  uint256 public h = 789; // 32 bytes -> slot 6
  // slot 4 => 0xc8 = 200 in decimal
  // slot 5 => 0x28 = 40 in decimal
  // slot 6 => 0x0315 = 789 in decimal
  // The order matters, g variable should go last or we will waste 31 bytes of a slot

 // init call of a smartcontract and its bytecode as a result
  constructor() {
    cc.push(1);
    cc.push(10);
    cc.push(100);

    aa[2] = 4;
    aa[3] = 10;

    bb[0xfcFBfE3f85E72b06443e0C856bb40b95488E06b5] = 100;
  }
  //// keccak256(key . slot) example to access mapping data structure values in the storage:
  /// aa[2] key hash -> 2 */
  // 0x0000000000000000000000000000000000000000000000000000000000000002
  /// storage slot of aa[2] -> 0
  // 0x0000000000000000000000000000000000000000000000000000000000000000
  /// paste both together: 
  // 00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000
  /// use keccak256, result:
  // abbb5caa7dda850e60932de0934eb1f9d0f59695050f761dc64e443e5030a569

  /// To check bb[0xfcFBfE3f85E72b06443e0C856bb40b95488E06b5]:
  // 0x000000000000000000000000fcFBfE3f85E72b06443e0C856bb40b95488E06b50000000000000000000000000000000000000000000000000000000000000001
  /// use keccak256, result:
  // 0x660a9c258346362863b76095373073e6e3f2c1d3e31471bc599df52f117e955e

  /// Check results on truffle console:
  // web3.eth.getStorageAt("0xb273A84409c9522F370FB068656027739E278236", "0xabbb5caa7dda850e60932de0934eb1f9d0f59695050f761dc64e443e5030a569");
}

/*
Get a value in the storage(Contract address & index) of an array:

/// keccak256(slot) + index of the item
// First array position:
Convert 0000000000000000000000000000000000000000000000000000000000000002 slot to keccak256 hex value
405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace
web3.eth.getStorageAt("0xa68D19D08A3131EB3BB1a64612c47fE2B417ae2C", "0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace");
// Second array position (convert hex to dec):
405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace :
29102676481673041902632991033461445430619272659676223336789171408008386403022 + 1 :
29102676481673041902632991033461445430619272659676223336789171408008386403023 (convert it to hex)
405787FA12A823E0F2B7631CC41B3BA8828B3321CA811111FA75CD3AA3BB5ACF
web3.eth.getStorageAt("0xa68D19D08A3131EB3BB1a64612c47fE2B417ae2C", "0x405787FA12A823E0F2B7631CC41B3BA8828B3321CA811111FA75CD3AA3BB5ACF");

Get a value in the storage(Contract address & index) of a variable:

web3.eth.getStorageAt("0xb273A84409c9522F370FB068656027739E278236", 0);
web3.eth.getStorageAt("0xa68D19D08A3131EB3BB1a64612c47fE2B417ae2C", 2);
*/