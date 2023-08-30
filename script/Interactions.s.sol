// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MyNFTToken} from "../src/MyNFTToken.sol";
import {MoodDynamicNFT} from "../src/MoodDynamicNFT.sol";

contract MintBasicPUGNft is Script {
    string public constant PUG_URI = "ipfs://QmfAN3qcwwccWZUH2SM1Nvo7xdvDfPTuGX3xCKcMeRPPTY?filename=1-PUG.json";
    // "ipfs://QmQAeXueHxb786TvEeQiMcfu5sb7ZVr3fFjJZDJQ11ga5M?filename=0-CUTE-PUG.json";
    uint256 deployerKey;

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools.get_most_recent_deployment("MyNFTToken", block.chainid);
        mintNFTOnContract(mostRecentlyDeployedBasicNft);
    }

    function mintNFTOnContract(address myNFTTokenContractAddress) public {
        vm.startBroadcast();
        MyNFTToken(myNFTTokenContractAddress).mintNft(PUG_URI);
        vm.stopBroadcast();
    }
}

contract MintMoodDynamicNFT is Script {
    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools.get_most_recent_deployment("MoodDynamicNFT", block.chainid);
        mintNftOnContract(mostRecentlyDeployedBasicNft);
    }

    function mintNftOnContract(address moodNftAddress) public {
        vm.startBroadcast();
        MoodDynamicNFT(moodNftAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract ChangeMoodNFT is Script {
    uint256 public constant TOKEN_ID_FOR_MOOD_CHANGE = 0;
    string public constant CHANGE_TO_MOOD = "EXCITED";

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools.get_most_recent_deployment("MoodDynamicNFT", block.chainid);
        changeMoodNFT(mostRecentlyDeployedBasicNft);
    }

    function changeMoodNFT(address moodNftAddress) public {
        vm.startBroadcast();
        MoodDynamicNFT(moodNftAddress).changeMood(TOKEN_ID_FOR_MOOD_CHANGE, CHANGE_TO_MOOD);
        vm.stopBroadcast();
    }
}
