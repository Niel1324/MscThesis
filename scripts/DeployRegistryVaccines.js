const { ethers } = require('hardhat');

async function main() {
  const API_URL = "https://eth-sepolia.g.alchemy.com/v2/i7Lghvhg9pXwKTWyTtXM-GRxzMqXpZur";
  const PRIVATE_KEY = 'ef011823a0126ac74377ef362795c7e07262845830511efce509285bc8497c88';

  const provider = new ethers.providers.JsonRpcProvider(API_URL);
  const deployer = new ethers.Wallet(PRIVATE_KEY, provider);
  console.log("Deploying contracts with the account:", deployer.address);

  // Get the current gas price
  const gasPrice = await provider.getGasPrice();
  console.log(`Current gas price: ${ethers.utils.formatUnits(gasPrice, 'gwei')} gwei`);

  // Get the current cost of 1 ETH
  const ethPrice = await getEthPrice(); // Assuming you have a function to fetch the current ETH price
  console.log(`Current cost of 1 ETH: $${ethPrice}`);
  const startTime = Date.now();

  // Deploy the contract
  const VaccineRegistry = await ethers.getContractFactory('VaccineRegistry');
  const vaccineRegistry = await VaccineRegistry.deploy();

  // Wait for the contract to be mined
  const transactionReceipt = await vaccineRegistry.deployTransaction.wait();
  
  // Record the end time and calculate the elapsed time
  const endTime = Date.now();
  const elapsedTime = (endTime - startTime) / 1000; // Convert milliseconds to seconds

  // Calculate the transaction cost in Gwei and USD
  const gasUsed = transactionReceipt.gasUsed;
  const transactionCostGwei = gasUsed.mul(gasPrice);
  const transactionCostEth = ethers.utils.formatEther(transactionCostGwei);
  const transactionCostUsd = (parseFloat(transactionCostEth) * ethPrice).toFixed(2);

  console.log('VaccineRegistry deployed to:', vaccineRegistry.address);
  console.log(`Deployment took ${elapsedTime.toFixed(2)} seconds.`);
  console.log(`Transaction cost: ${ethers.utils.formatUnits(transactionCostGwei, 'gwei')} gwei (${transactionCostEth} ETH)`);
  console.log(`Transaction cost in USD: $${transactionCostUsd}`);
}
// Add a function to fetch the current price of ETH in USD using a free API like CoinGecko
async function getEthPrice() {
  const response = await fetch('https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd');
  const data = await response.json();
  return data.ethereum.usd;
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });