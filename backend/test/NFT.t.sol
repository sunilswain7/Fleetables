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
}