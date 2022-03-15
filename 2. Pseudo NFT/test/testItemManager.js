//see more here -> https://trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript.html

const ItemManager = artifacts.require("./itemManager.sol"); //parsa l'ItemManager.json automaticamente

//inizio test
contract("ItemManager", accounts => {
  //it should do that
  it("Description of your test. Example: should be able to add an Item", async() => {
    const itemManagerInstance = await ItemManager.deployed();
    const itemName = "test1"
    const itemPrice = 500

    const result = await itemManagerInstance.createItem(itemName, itemPrice, {from: accounts[0]})
    assert.equal(result.logs[0].args._itemIndex, 0, "It's not the first item");

    const item = await itemManagerInstance.items(0);
    assert.equal(item._identifier, itemName, "The identifier was different");
  })
});