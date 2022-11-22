const { ethers } = require("hardhat")

async function main() {
  const votingContract = await ethers.getContractFactory("Voting");

  const deployedVotingContract = await votingContract.deploy();
  await deployedVotingContract.deployed();
  const votingAddress = deployedVotingContract.address;

  console.log(`voting dapp address: ${votingAddress}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
