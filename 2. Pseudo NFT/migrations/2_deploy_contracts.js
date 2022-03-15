var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var ItemManager = artifacts.require("./ItemManager.sol");

module.exports = function(deployer) {
    deployer.deploy(SimpleStorage);
    deployer.deploy(ItemManager);
};