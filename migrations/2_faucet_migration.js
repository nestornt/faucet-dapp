// Requiere el nombre del contrato compilado en bytecode en la ruta /build
// We will get the bytecode of the smartcontract to deploy it to the blockchain 
const FaucetContract = artifacts.require("Faucet");

module.exports = function (deployer) { // deployer is injected by truffle
  // We specify the contract to deploy
  deployer.deploy(FaucetContract);
}