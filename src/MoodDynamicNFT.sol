// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodDynamicNFT is ERC721 {
    //ERRORS
    error MoodNft__CannotChangeMoodIfNotOwner();
    error MoodNft__AlreadyInSameMood();
    error MoodNft__InvalidMood();
    error MoodNft__UnknownError();

    uint256 private s_tokenCounter;

    string private s_happySVGImageUri;
    string private s_sadSVGImageUri;
    string private s_excitedSVGImageUri;
    string private s_neutralSVGImageUri;

    enum MOOD {
        HAPPY,
        SAD,
        EXCITED,
        NEUTRAL
    }

    mapping(uint256 => MOOD) private s_tokenIdToMood;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(
        string memory happySVGImageUri,
        string memory sadSVGImageUri,
        string memory excitedSVGImageUri,
        string memory neutralSVGImageUri
    ) ERC721("MYMOODNFT", "MOOD") {
        s_tokenCounter = 0;

        s_happySVGImageUri = happySVGImageUri;
        s_sadSVGImageUri = sadSVGImageUri;

        s_excitedSVGImageUri = excitedSVGImageUri;
        s_neutralSVGImageUri = neutralSVGImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = MOOD.HAPPY;
        s_tokenCounter++;
        emit CreatedNFT(s_tokenCounter);
    }

    function enumToString(MOOD _moodState) internal pure returns (string memory) {
        if (_moodState == MOOD.HAPPY) return "HAPPY";
        if (_moodState == MOOD.SAD) return "SAD";
        if (_moodState == MOOD.EXCITED) return "EXCITED";
        if (_moodState == MOOD.NEUTRAL) return "NEUTRAL";

        revert MoodNft__InvalidMood();
    }

    function changeMood(uint256 tokenId, string memory whatsYourMood) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CannotChangeMoodIfNotOwner();
        }

        if (
            keccak256(abi.encodePacked(enumToString(getCurrentMood(tokenId))))
                == keccak256(abi.encodePacked(whatsYourMood))
        ) {
            revert MoodNft__AlreadyInSameMood();
        }

        string memory moodAsString1 = enumToString(MOOD.HAPPY);
        string memory moodAsString2 = enumToString(MOOD.SAD);
        string memory moodAsString3 = enumToString(MOOD.EXCITED);
        string memory moodAsString4 = enumToString(MOOD.NEUTRAL);

        bool isValidMoodCheck = (
            keccak256(abi.encodePacked(whatsYourMood)) != keccak256(abi.encodePacked(moodAsString1))
        ) && (keccak256(abi.encodePacked(whatsYourMood)) != keccak256(abi.encodePacked(moodAsString2)))
            && (keccak256(abi.encodePacked(whatsYourMood)) != keccak256(abi.encodePacked(moodAsString3)))
            && (keccak256(abi.encodePacked(whatsYourMood)) != keccak256(abi.encodePacked(moodAsString4)));

        if (isValidMoodCheck) {
            revert MoodNft__InvalidMood();
        }

        if (keccak256(abi.encodePacked(whatsYourMood)) == keccak256(abi.encodePacked(moodAsString1))) {
            s_tokenIdToMood[tokenId] = MOOD.HAPPY;
        } else if (keccak256(abi.encodePacked(whatsYourMood)) == keccak256(abi.encodePacked(moodAsString2))) {
            s_tokenIdToMood[tokenId] = MOOD.SAD;
        } else if (keccak256(abi.encodePacked(whatsYourMood)) == keccak256(abi.encodePacked(moodAsString3))) {
            s_tokenIdToMood[tokenId] = MOOD.EXCITED;
        } else if (keccak256(abi.encodePacked(whatsYourMood)) == keccak256(abi.encodePacked(moodAsString4))) {
            s_tokenIdToMood[tokenId] = MOOD.NEUTRAL;
        } else {
            revert MoodNft__UnknownError();
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == MOOD.HAPPY) {
            imageURI = s_happySVGImageUri;
        } else if (s_tokenIdToMood[tokenId] == MOOD.SAD) {
            imageURI = s_sadSVGImageUri;
        } else if (s_tokenIdToMood[tokenId] == MOOD.EXCITED) {
            imageURI = s_excitedSVGImageUri;
        } else if (s_tokenIdToMood[tokenId] == MOOD.NEUTRAL) {
            imageURI = s_neutralSVGImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"MoodNFT is a dynamic NFT that reflects the mood of the owner, 100% on Chain! Originally Created by Patrick Collins (@PatrickAlphaC) & Enhanced by Nishant V (@itznish)", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    // GETTERS
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getCurrentMood(uint256 tokenId) public view returns (MOOD) {
        return s_tokenIdToMood[tokenId];
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySVGImageUri;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSVGImageUri;
    }

    function getExcitedSVG() public view returns (string memory) {
        return s_excitedSVGImageUri;
    }

    function getNeutralSVG() public view returns (string memory) {
        return s_neutralSVGImageUri;
    }
}
