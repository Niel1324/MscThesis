// Specifies the version of Solidity, using semantic versioning.
// Learn more: https://solidity.readthedocs.io/en/v0.5.10/layout-of-source-files.html#pragma

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ProfilePictureNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Mapping from owner to a list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    constructor() ERC721("ProfilePictureNFT", "PPNFT") {}

    function mintNFT(address recipient, string memory tokenURI) public returns (uint256) {
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();

        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
    // Update the list of owned tokens for the recipient
    _ownedTokens[recipient].push(newTokenId);

    return newTokenId;
}

function burnNFT(uint256 tokenId) public {
    // Ensuring that the function caller is the owner of the token
    require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not the owner of the NFT");

    // Burn the NFT
    _burn(tokenId);
}

// New function to retrieve the tokens owned by an address
function tokensOfOwner(address owner) public view returns (uint256[] memory) {
    return _ownedTokens[owner];
}
}