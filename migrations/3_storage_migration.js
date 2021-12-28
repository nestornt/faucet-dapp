const Storage = artifacts.require("Storage");

module.exports = function (deployer) { // deployer is injected by truffle
  // We specify the contract to deploy
  deployer.deploy(Storage);
}