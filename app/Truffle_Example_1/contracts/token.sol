// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "../@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../@openzeppelin/contracts/access/Ownable.sol";
import "../@openzeppelin/contracts/utils/Counters.sol";

// interface InterfaceFBToken{
//   function rewardToken(address user_addr) external;
//   function balanceOf(address user_addr) external returns(uint);
//   function deduct_tokens(uint tokens, address user_addr) external;
// }

contract FddToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address chairperson;

    constructor() ERC721("FDDToken", "TRUZ") {
      chairperson = msg.sender;
    }
    
    function rewardToken(address user_addr) external{
      safeMint(user_addr, "1");
    } 

    // function deduct_tokens(uint tokens, address user_addr) external{
    //   safeTransferFrom(user_addr, chairperson, tokens);
    // }

    function _baseURI() internal pure override returns (string memory) {
        return "https://example.com/nft/";
    }

    function safeMint(address to, string memory uri) internal{
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public  view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}