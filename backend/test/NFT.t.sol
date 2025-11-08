//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "../src/NFT.sol";

contract NFTTest is Test {
    NFT private nft;
    address private user = address(0x1);

    function setUp() public {
        nft = new NFT();
    }

    function testMintNFT() public {
        string memory tokenURI = "https://example.com/nft/1";

        vm.prank(user);
        uint256 tokenId = nft.mintNFT(tokenURI);

        assertEq(tokenId, 1);
        assertEq(nft.ownerOf(tokenId), user);
        assertEq(nft.tokenURI(tokenId), tokenURI);
    }

    function testMintMultipleNFTs() public {
        string memory tokenURI1 = "https://example.com/nft/1";
        string memory tokenURI2 = "https://example.com/nft/2";

        vm.prank(user);
        uint256 tokenId1 = nft.mintNFT(tokenURI1);
        vm.prank(user);
        uint256 tokenId2 = nft.mintNFT(tokenURI2);

        assertEq(tokenId1, 1);
        assertEq(tokenId2, 2);
        assertEq(nft.ownerOf(tokenId1), user);
        assertEq(nft.ownerOf(tokenId2), user);
        assertEq(nft.tokenURI(tokenId1), tokenURI1);
        assertEq(nft.tokenURI(tokenId2), tokenURI2);
    }

    function testMintNFTFromDifferentUsers() public {
        address user2 = address(0x2);
        string memory tokenURI1 = "https://example.com/nft/1";
        string memory tokenURI2 = "https://example.com/nft/2";

        vm.prank(user);
        uint256 tokenId1 = nft.mintNFT(tokenURI1);
        vm.prank(user2);
        uint256 tokenId2 = nft.mintNFT(tokenURI2);

        assertEq(tokenId1, 1);
        assertEq(tokenId2, 2);
        assertEq(nft.ownerOf(tokenId1), user);
        assertEq(nft.ownerOf(tokenId2), user2);
        assertEq(nft.tokenURI(tokenId1), tokenURI1);
        assertEq(nft.tokenURI(tokenId2), tokenURI2);
    }

    function testMintNFTIncrementsTokenId() public {
        string memory tokenURI1 = "https://example.com/nft/1";
        string memory tokenURI2 = "https://example.com/nft/2";
        string memory tokenURI3 = "https://example.com/nft/3";

        vm.prank(user);
        uint256 tokenId1 = nft.mintNFT(tokenURI1);
        vm.prank(user);
        uint256 tokenId2 = nft.mintNFT(tokenURI2);
        vm.prank(user);
        uint256 tokenId3 = nft.mintNFT(tokenURI3);

        assertEq(tokenId1 + 1, tokenId2);
        assertEq(tokenId2 + 1, tokenId3);
        assertEq(tokenId1 + 2, tokenId3);
    }

}