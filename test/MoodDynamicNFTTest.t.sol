// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

// import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MoodDynamicNFT} from "../src/MoodDynamicNFT.sol";

contract MoodDynamicNFTTest is StdCheats, Test {
    MoodDynamicNFT public moodNFT;

    string public constant HAPPY_SVG_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";

    string public constant SAD_SVG_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNNTEyIDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYgNDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcyczE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIvPgogIDxwYXRoIGZpbGw9IiNFNkU2RTYiIGQ9Ik01MTIgMTQwYy0yMDUuNCAwLTM3MiAxNjYuNi0zNzIgMzcyczE2Ni42IDM3MiAzNzIgMzcyIDM3Mi0xNjYuNiAzNzItMzcyLTE2Ni42LTM3Mi0zNzItMzcyek0yODggNDIxYTQ4LjAxIDQ4LjAxIDAgMCAxIDk2IDAgNDguMDEgNDguMDEgMCAwIDEtOTYgMHptMzc2IDI3MmgtNDguMWMtNC4yIDAtNy44LTMuMi04LjEtNy40QzYwNCA2MzYuMSA1NjIuNSA1OTcgNTEyIDU5N3MtOTIuMSAzOS4xLTk1LjggODguNmMtLjMgNC4yLTMuOSA3LjQtOC4xIDcuNEgzNjBhOCA4IDAgMCAxLTgtOC40YzQuNC04NC4zIDc0LjUtMTUxLjYgMTYwLTE1MS42czE1NS42IDY3LjMgMTYwIDE1MS42YTggOCAwIDAgMS04IDguNHptMjQtMjI0YTQ4LjAxIDQ4LjAxIDAgMCAxIDAtOTYgNDguMDEgNDguMDEgMCAwIDEgMCA5NnoiLz4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNMjg4IDQyMWE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6bTIyNCAxMTJjLTg1LjUgMC0xNTUuNiA2Ny4zLTE2MCAxNTEuNmE4IDggMCAwIDAgOCA4LjRoNDguMWM0LjIgMCA3LjgtMy4yIDguMS03LjQgMy43LTQ5LjUgNDUuMy04OC42IDk1LjgtODguNnM5MiAzOS4xIDk1LjggODguNmMuMyA0LjIgMy45IDcuNCA4LjEgNy40SDY2NGE4IDggMCAwIDAgOC04LjRDNjY3LjYgNjAwLjMgNTk3LjUgNTMzIDUxMiA1MzN6bTEyOC0xMTJhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAweiIvPgo8L3N2Zz4=";

    string public constant EXCITED_SVG_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPHBvbHlnb24gcG9pbnRzPSI1MCwwIDIxLDkwIDk4LDM1IDIsMzUgNzksOTAiCiAgICBzdHlsZT0iZmlsbDpkYXJrb3JhbmdlO3N0cm9rZS13aWR0aDoxO2ZpbGwtcnVsZTpub256ZXJvIgogICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTksMjApIHNjYWxlKDAuOCkiIC8+CiAgICA8cG9seWdvbiBwb2ludHM9IjUwLDAgMjEsOTAgOTgsMzUgMiwzNSA3OSw5MCIKICAgIHN0eWxlPSJmaWxsOmRhcmtvcmFuZ2U7c3Ryb2tlLXdpZHRoOjE7ZmlsbC1ydWxlOm5vbnplcm8iCiAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMDEsMjApIHNjYWxlKDAuOCkiIC8+CiAgPC9nPgogICA8bGluZSB4MT0iMTM5IiB5MT0iMTE1IiB4Mj0iNTMuNSIgeTI9IjExNSIgc3R5bGU9InN0cm9rZTpibGFjaztzdHJva2Utd2lkdGg6My41IiAvPgogIDxwYXRoIGQ9Im0xMzYuODEgMTE2LjUzYy42OSAyNi4xNy02NC4xMSA0Mi04MS41Mi0uNzMiIHN0eWxlPSJmaWxsOnJlZDsgc3Ryb2tlOiBibGFjazsgc3Ryb2tlLXdpZHRoOiA0OyIvPgo8L3N2Zz4=";

    string public constant NEUTRAL_SVG_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0iaXZvcnkiIHI9Ijc4IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjMiLz4KICA8ZyBjbGFzcz0iZXllcyI+CiAgICA8Y2lyY2xlIGN4PSI2MiIgY3k9IjgwIiByPSIxMCIvPgogICAgPGNpcmNsZSBjeD0iMTMyIiBjeT0iODAiIHI9IjEwIi8+CiAgPC9nPgogICA8bGluZSB4MT0iMTQyIiB5MT0iMTMwIiB4Mj0iNTUiIHkyPSIxMzAiIHN0eWxlPSJzdHJva2U6YmxhY2s7c3Ryb2tlLXdpZHRoOjMuNSIgLz4KPC9zdmc+";

    address public constant MINTER = address(1);

    function setUp() external {
        moodNFT = new MoodDynamicNFT(HAPPY_SVG_URI, SAD_SVG_URI, EXCITED_SVG_URI, NEUTRAL_SVG_URI);
    }

    function testsForTokenUri() public {
        vm.prank(MINTER);

        moodNFT.mintNft();
        console.log(moodNFT.tokenURI(0));
    }
}
