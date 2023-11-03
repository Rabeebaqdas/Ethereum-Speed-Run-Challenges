import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat/";
import { DiceGame, RiggedRoll } from "../typechain-types";

const deployRiggedRoll: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const diceGame: DiceGame = await ethers.getContract("DiceGame");

  await deploy("RiggedRoll", {
    from: deployer,
    log: true,
    args: [diceGame.address],
    autoMine: true,
  });

  const riggedRoll: RiggedRoll = await ethers.getContract("RiggedRoll", deployer);
  console.log("=== owner",await riggedRoll.owner());

  // Please replace the text "Your Address" with your own address. if theres a new owner
  // try {
  //   const tx = await riggedRoll.transferOwnership("0x808f0597D8B83189ED43d61d40064195F71C0D15");
  //   await tx.wait();
  //   console.log("===new owner",await riggedRoll.owner());
    
  // } catch (err) {
  //   console.log(err);
  // }


};

export default deployRiggedRoll;

deployRiggedRoll.tags = ["RiggedRoll"];
