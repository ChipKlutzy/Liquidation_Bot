const { ethers } = require("hardhat");

const AAVE_PROVIDER = '0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5'
const UNI_PROVIDER = '0xf164fC0Ec4E93095b804a4795bBe1e041497b92a'

async function main() {

  const accounts = await ethers.getSigners()

  const LiquidationBot = await ethers.getContractFactory("LiquidationBot");
  const liquidationBot = await LiquidationBot.connect(accounts[0]).deploy(AAVE_PROVIDER, UNI_PROVIDER);

  await liquidationBot.deployed();

  console.log(`Your LIQUIDATION BOT Deployed @ Address: ${liquidationBot.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// 0x47c05BCCA7d57c87083EB4e586007530eE4539e9