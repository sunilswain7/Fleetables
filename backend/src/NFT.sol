//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    uint256 private _tokenIds;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds++;
        _safeMint(msg.sender, _tokenIds);
        _setTokenURI(_tokenIds, tokenURI);
        return _tokenIds;
    }
}