pragma solidity >=0.5.0 <0.6.0;
import "./erc721.sol";
import "./safemath.sol";

contract art_work is ERC721 {
    using SafeMath for uint256;
    struct art {
        string name;
        uint year;
    }

    art[] artList;
    mapping (uint => address) artToOwner;
    mapping (address => uint) ownerArtCount;
    mapping (uint => address) artApprovals;
    function addArt(string memory _name, uint _year) public {
        uint id = artList.push(art (_name, _year));
        artToOwner[id] = msg.sender;
        ownerArtCount[msg.sender] = ownerArtCount[msg.sender].add(1);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerArtCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return artToOwner[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require (artToOwner[_tokenId] == msg.sender || artApprovals[_tokenId] == msg.sender);
        ownerArtCount[_to] = ownerArtCount[_to].add(1);
        ownerArtCount[msg.sender] = ownerArtCount[msg.sender].sub(1);
        artToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        require(artToOwner[_tokenId] == msg.sender);
        artApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
