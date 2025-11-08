//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Marketplace.sol";

contract MarketplaceTest is Test {
    Marketplace private marketplace;
    address private user = address(0x1);

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
}