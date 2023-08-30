// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MoodDynamicNFT} from "../src/MoodDynamicNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodDynamicNFT is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (MoodDynamicNFT) {
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        }

        string memory happySvg = vm.readFile("./img/happy.svg");
        string memory sadSvg = vm.readFile("./img//sad.svg");
        string memory excitedSvg = vm.readFile("./img/excited.svg");
        string memory neutralSvg = vm.readFile("./img/neutral.svg");

        vm.startBroadcast(deployerKey);
        MoodDynamicNFT moodNft = new MoodDynamicNFT(
            svgToImageURI(happySvg),
            svgToImageURI(sadSvg),
            svgToImageURI(excitedSvg),
            svgToImageURI(neutralSvg)
        );
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
