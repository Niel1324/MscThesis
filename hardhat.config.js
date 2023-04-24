/**
* @type import('hardhat/config').HardhatUserConfig
*/

require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const {PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.1",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/i7Lghvhg9pXwKTWyTtXM-GRxzMqXpZur`,
      accounts: [`0x${PRIVATE_KEY}`],
      gasPrice: 20000000000, // 20 Gwei
    },
  },
};
