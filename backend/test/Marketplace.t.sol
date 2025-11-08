//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/NFT.sol";
import "../src/Marketplace.sol";

contract MarketplaceTest is Test {
    Marketplace private marketplace;
    address private user = address(0x100);

    function setUp() public {
        vm.prank(user);
        marketplace = new Marketplace(1); // 1% fee
    }

    function testInitialValues() public {
        vm.prank(user);
        assertEq(marketplace.feeAccount(), user);
        assertEq(marketplace.feePercent(), 1);
        assertEq(marketplace.itemCount(), 0);
    }
    
    function testMakeItem() public {
        vm.prank(user);
        NFT nft = new NFT();

        vm.prank(user);
        uint256 tokenId = nft.mintNFT("https://example.com/nft/1");
        vm.prank(user);
        nft.approve(address(marketplace), tokenId);
        vm.prank(user);
        marketplace.makeItem(IERC721(address(nft)), tokenId, 1 ether);
        (uint256 itemId, IERC721 nftAddress, uint256 listedTokenId, uint256 price, address seller, bool sold) = marketplace.items(1);
        assertEq(itemId, 1);
        assertEq(address(nftAddress), address(nft));
        assertEq(listedTokenId, tokenId);
        assertEq(price, 1 ether);
        assertEq(seller, user);
        assertEq(sold, false); 

    }

    function testMakeItemFailsWithZeroPrice() public {
        vm.prank(user);
        NFT nft = new NFT();

        vm.prank(user);
        uint256 tokenId = nft.mintNFT("https://example.com/nft/1");
        vm.prank(user);
        nft.approve(address(marketplace), tokenId);
        vm.prank(user);
        vm.expectRevert("Price must be greater than zero");
        marketplace.makeItem(IERC721(address(nft)), tokenId, 0);
    }

    function testMakeMultipleItems() public {
        vm.prank(user);
        NFT nft = new NFT();

        vm.prank(user);
        uint256 tokenId1 = nft.mintNFT("https://example.com/nft/1");
        vm.prank(user);
        nft.approve(address(marketplace), tokenId1);
        vm.prank(user);
        marketplace.makeItem(IERC721(address(nft)), tokenId1, 1 ether);

        vm.prank(user);
        uint256 tokenId2 = nft.mintNFT("https://example.com/nft/2");
        vm.prank(user);
        nft.approve(address(marketplace), tokenId2);
        vm.prank(user);
        marketplace.makeItem(IERC721(address(nft)), tokenId2, 2 ether);

        (uint256 itemId1, , , uint256 price1, , ) = marketplace.items(1);
        (uint256 itemId2, , , uint256 price2, , ) = marketplace.items(2);

        assertEq(itemId1, 1);
        assertEq(price1, 1 ether);
        assertEq(itemId2, 2);
        assertEq(price2, 2 ether);
    }

    function testBuyItem() public {
        vm.prank(user);
        NFT nft = new NFT();

        vm.prank(user);
        uint256 tokenId = nft.mintNFT("https://example.com/nft/1");
        vm.prank(user);
        nft.approve(address(marketplace), tokenId);
        vm.prank(user);
        marketplace.makeItem(IERC721(address(nft)), tokenId, 1 ether);
        address buyer = address(0x2);
        uint256 totalPrice = marketplace.getTotalPrice(1);
        vm.deal(buyer, totalPrice);
        vm.prank(buyer);
        marketplace.BuyItem{value: totalPrice}(1);
        (, , , , , bool sold) = marketplace.items(1);
        assertEq(sold, true);
        assertEq(nft.ownerOf(tokenId), buyer);

    }
}