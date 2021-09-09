pragma solidity ^0.5.7;


/**
 * @notice Based on:
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
 * Requires EIP-1052.
 * @dev Utility library of inline functions on addresses.
 */
library AddressUtils
{

  /**
   * @dev Returns whether the target address is a contract.
   * @param _addr Address to check.
   * @return addressCheck True if _addr is a contract, false if not.
   */
  function isContract(
    address _addr
  )
    internal
    view
    returns (bool addressCheck)
  {
    // This method relies in extcodesize, which returns 0 for contracts in
    // construction, since the code is only stored at the end of the
    // constructor execution.

    // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
    // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
    // for accounts without code, i.e. `keccak256('')`
    bytes32 codehash;
    bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    assembly { codehash := extcodehash(_addr) } // solhint-disable-line
    addressCheck = (codehash != 0x0 && codehash != accountHash);
  }

};

Interface ERC721TokenReceiver {
    function onERC21 Received(address _operator, address _from, uint _tokenId, bytes _data)external returns(bytes4);
}

contract ERC721Token  /* is ERC165 */ {
    
    
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
};

contract ERC721Token is ERC721 {
    using AddressUtils for  address; 
    mapping (address => uint) private ownerToTokenCount:
    mapping (uint => address)private idToOwner;
    mapping(uint => address) private idToApproved;
    mapping(address => mapping(address => bool))private ownerToOperators
    bytes4 internal constant MAGIC_ON_ERC721_RECIEVED = 0x150b7a02;
    
    function balanceOf(address _owner) external view returns (uint){
        return ownerToTokenCount[_owner];
    }
    
    function ownerOf(uint256 _tokenId) external view returns (address)
    return idToOwner[_tokenId];
    
    
    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes calldata data) external payable;
        _safeTransferFrom(_from, _to, _tokenId, data); 
    
    function safeTransferFrom(address _from, address _to, uint _tokenId) external payable;
    _safeTransferFrom(_from, _to, _tokenId, ""); 
}
   function transferFrom(address _from, address _to, uin _tokenId) external payable{
     _transfer(_from, _to, _tokenId);
   }
   
   function approve(address _approved, uint _tokenId) external payable {
       address owner = idToOwner[_tokenId];
       require(msg.sender == owner, 'not authorized';)
       idToApproved[_tokenId] = _approved;
       emit Approval(owner, _approved, __tokenId);
   }
   
   function setApprovalForAll(address _operator, bool _approved) external{
       ownerToOperators[msg.sender][_operator]= _approved;
      emit ApprovalForAll(msg.sender,  _operator, _approved);
   }
   
   function getApproved(uint256 _tokenId) external view returns (address){
       return idToApproved[_tokenId];
   }
   
   function isApprovedForAll(address _owner, address _operator) external view returns (bool){
      return  ownerToOperators[_owner][_operator];
   }

    function _safeTransferFrom(address _from, address _to, uint __tokenId, bytes memory data) internal {
       _transfer(_from, _to, _tokenId);
       
       if(_to.isContract()){
          bytes4 retval = ERC721TokenReceiver(_to).onERC21Received(msg.sender, _from, _tokenId, data);/*call this smart contract, execute a pre-defined function*/
           require(retval == MAGIC_ON_ERC721_RECIEVED, 'receipient smart contract cannot handle ERC721 tokens');
       }
       
       
    }
    
    function _transfer(address _from, address _, uint _tokenId) 
       internal
       can Transfer(_tokenId) {
       ownerToTokenCount[_from] -= 1;
       ownerToTokenCount[_to] +=1;
       idToOwner[token] = _to;
       emit transfer (_from, _to, _tokenId);
       
    }
    
    modifier canTransfer(uint tokenId){
        address owner = idToOwner[_tokenId];
        require(owner == msg.sender 
        || idToApproved[_tokenId] == msg.sender
        || ownerToOperators[owner][msg.sender] == true,'transfer not authorized');
        _;
    }
   
   
   
   
   
   
   
   

