// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Address: 0x85879110E68b32589c58564f1c5497428F2c85D8

contract Metaverse is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    uint256 public maxSupply = 100;
    uint256 public cost = 0.01 ether;
    uint256 private _nextTokenId;

    string private baseTokenURI =
        "https://rakshit-singh2.github.io/sample-images/metadata/";
    string private contractMetadataURI =
        "https://avatars.githubusercontent.com/u/157013246?v=4";

    struct Building {
        string name;
        int8 w;
        int8 h;
        int8 d;
        int8 x;
        int8 y;
        int8 z;
    }

    // Mapping from owner to their list of buildings
    mapping(address => Building[]) private NFTOwners;

    Building[] public buildings;

    // Events
    event BuildingMinted(
        address indexed owner,
        uint256 indexed tokenId,
        string name
    );
    event Withdrawal(address indexed to, uint256 amount);

    constructor(address initialOwner)
        ERC721("METAVERSE", "META")
        Ownable(initialOwner)
    {}

    /// @notice Mint a new building NFT
    function mint(
        string memory _name,
        int8 _w,
        int8 _h,
        int8 _d,
        int8 _x,
        int8 _y,
        int8 _z
    ) public payable {
        require(_nextTokenId < maxSupply, "Max supply reached");
        require(msg.value >= cost, "Insufficient payment");

        uint256 tokenId = _nextTokenId++;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(
            tokenId,
            string(
                abi.encodePacked(
                    baseTokenURI,
                    "image-",
                    Strings.toString(tokenId + 1),
                    ".json"
                )
            )
        );

        Building memory newBuilding = Building(
            _name,
            _w,
            _h,
            _d,
            _x,
            _y,
            _z
        );
        buildings.push(newBuilding);
        NFTOwners[msg.sender].push(newBuilding);

        emit BuildingMinted(msg.sender, tokenId, _name);
    }

    /// @notice Get all buildings
    function getBuildings() public view returns (Building[] memory) {
        return buildings;
    }

    // Obtain a user's Metaverse buildings
    function getOwnerBuildings() public view returns (Building[] memory) {
        return NFTOwners[msg.sender];
    }

    /// @notice Owner withdraws all contract balance
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");

        address payable ownerAddress = payable(owner());
        (bool success, ) = ownerAddress.call{value: balance}("");
        require(success, "Withdrawal failed");

        emit Withdrawal(ownerAddress, balance);
    }

    /// @notice Returns contract-level metadata URI (for marketplaces like OpenSea)
    function contractURI() public view returns (string memory) {
        return contractMetadataURI;
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
