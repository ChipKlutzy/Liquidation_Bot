require("@nomicfoundation/hardhat-toolbox");

const DEFAULT_COMPILER_SETTINGS = {
  version: '0.6.2',
}

const COMPILER_SETTINGS = {
  version: '0.8.10',
}

const COMPILER_SETTINGS_01 = {
  version: '0.6.12',
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      DEFAULT_COMPILER_SETTINGS, 
      COMPILER_SETTINGS,
      COMPILER_SETTINGS_01
    ]
  },
  networks: {
    hardhat: {
      forking: {
        url: 'https://eth-mainnet.g.alchemy.com/v2/lqFZPX_TIv4EFkkrZ5ieYLqRNgI-XjFc',
      },
    },
  },
};
