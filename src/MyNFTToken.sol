// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFTToken is ERC721 {
    uint256 private s_tokenCounter;

    mapping(uint256 => string) s_tokenIdToURI; // tokenURI mapper;

    constructor() ERC721("DOGIES TOKEN", "DOGI") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory _tokenUri) public {
        s_tokenIdToURI[s_tokenCounter] = _tokenUri;

        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToURI[tokenId];
    }
}
