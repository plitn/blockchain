const main = async () => {
    const [deployer] = await ethers.getSigners();
    console.log(`Adress deploying the contract -> ${deployer.address}`);
  
    const tokenFactory = await ethers.getContractFactory("DmitrinPA");
    const contract = await tokenFactory.deploy();
  
    console.log(`Token contract address -> ${contract.address}`);
  };
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.log(error);
      process.exit(1);
    });