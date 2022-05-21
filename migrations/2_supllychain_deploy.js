var SupplyChain = artifacts.require("SupplyChain");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(SupplyChain);
};
