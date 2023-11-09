const ItemManager = artifacts.require('ItemManager');
const Item = artifacts.require('Item');

contract('ItemManager', (accounts) => {
  let itemContractAddress;
  let itemName = 'iPhone 13';
  let itemPrice = 1200;
  let itemManagerInstance;
  let owner = accounts[0];

  it('Item should be created', async () => {
    itemManagerInstance = await ItemManager.deployed(owner);
    const tx = await itemManagerInstance.createItem(itemName, itemPrice, { from: owner });
    itemContractAddress = tx.logs[0].args._itemAddress;

    assert.equal(tx.logs[0].args._index, 0, 'Not the first item');
  });

  it(`Sending Item contract for payment`, async () => {
    await web3.eth.sendTransaction({ from: accounts[2], to: itemContractAddress, value: itemPrice, gas: 300000 });
    const tx = await itemManagerInstance.items(0);
    assert.equal(tx._state, 1, "Item didn't paid yet");
  });

  it(`Mark Items as delivered`, async () => {
    const tx = await itemManagerInstance.triggerDelivery(0, { from: owner });
    assert.equal(tx.logs[0].args._state, 2, "Couldn't deliver didn't paid yet.");
  });
});
