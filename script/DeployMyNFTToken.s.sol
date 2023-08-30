// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {Script} from "forge-std/Script.sol";
import {MyNFTToken} from "../src/MyNFTToken.sol";

contract DeployMyNFTToken is Script {
    function run() external returns (MyNFTToken) {
        vm.startBroadcast();
        MyNFTToken myNFTToken = new MyNFTToken();

        vm.stopBroadcast();
        return myNFTToken;
    }
}
