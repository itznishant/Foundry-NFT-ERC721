// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {DeployMyNFTToken} from "../script/DeployMyNFTToken.s.sol";
import {MyNFTToken} from "../src/MyNFTToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MintBasicPUGNft} from "../script/Interactions.s.sol";

contract MyNFTTokenTest is StdCheats, Test {
    DeployMyNFTToken public deployer;
    MyNFTToken public myNFTToken;

    string public constant PUG_METADATA =
        "ipfs://QmQAeXueHxb786TvEeQiMcfu5sb7ZVr3fFjJZDJQ11ga5M?filename=0-CUTE-PUG.json";

    address public USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMyNFTToken();
        myNFTToken = deployer.run();
    }

    function testNFTNameAndSymbolAreCorrect() external {
        string memory expectedName = "DOGIES TOKEN";
        string memory name = myNFTToken.name();

        string memory expectedSymbol = "DOGI";
        string memory symbol = myNFTToken.symbol();

        assertEq(keccak256(abi.encodePacked(expectedName)), keccak256(abi.encodePacked(name)));
        assertEq(keccak256(abi.encodePacked(expectedSymbol)), keccak256(abi.encodePacked(symbol)));
    }

    function testUserCanMintNFT() external {
        vm.prank(USER);

        myNFTToken.mintNft(PUG_METADATA);

        assert(myNFTToken.balanceOf(USER) == 1);
        //tokenURI assert
        assertEq(keccak256(abi.encodePacked(PUG_METADATA)), keccak256(abi.encodePacked(myNFTToken.tokenURI(0))));
    }
}
