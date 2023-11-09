import { useState } from 'react';
import useEth from '../../contexts/EthContext/useEth';

function SupplyChain({ setValue }) {
  const {
    state: { contract, accounts },
  } = useEth();

  console.log({ contract });

  //   listenToEvents();
  const [cost, setCost] = useState('');
  const [itemName, setItemName] = useState('');

  const handleCostChange = (e) => {
    setCost(e.target.value);
  };
  const handleItemNameChange = (e) => {
    setItemName(e.target.value);
  };

  const handleSubmit = async () => {
    console.log({ itemName, cost });
    const tx = await contract.methods.createItem(itemName, cost).send({ from: accounts[0] });
    console.log({ tx });
    console.log(tx.events.SupplyChainProgress.returnValues._itemAddress);
  };

  return (
    <div className='container'>
      {accounts}
      <div className='inputs'>
        <div>
          <input type='text' placeholder='Cost' value={cost} onChange={handleCostChange} />
        </div>
        <div>
          <input type='text' placeholder='Item name' value={itemName} onChange={handleItemNameChange} />
        </div>
      </div>
      <button onClick={handleSubmit}>Submit</button>
    </div>
  );
}

export default SupplyChain;
