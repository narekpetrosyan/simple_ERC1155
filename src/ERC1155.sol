// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./IERC1155.sol";

contract ERC1155 is IERC1155 {
    string public name;
    address public owner;

    mapping(uint256 => mapping(address => uint256)) _balances;
    mapping(address => mapping(address => bool)) _operatorApprovals;

    constructor(string memory _name) {
        owner = msg.sender;
        name = _name;
    }

    function balanceOf(
        address _owner,
        uint256 _id
    ) public view returns (uint256) {
        return _balances[_id][_owner];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _values
    ) public {
        require(
            _from == msg.sender || isApprovedForAll(_from, msg.sender),
            "not approved"
        );
        require(_to != address(0), "cant transfer to zero address");
        require(_ids.length == _values.length, "lenghts doesn't match");

        for (uint256 i = 0; i < _ids.length; i++) {
            require(
                _balances[_ids[i]][_from] >= _values[i],
                "insufficient funds"
            );
            _balances[_ids[i]][_from] -= _values[i];
            _balances[_ids[i]][_to] += _values[i];
        }
    }

    function singleTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value
    ) public {
        require(
            _from == msg.sender || isApprovedForAll(_from, msg.sender),
            "not approved"
        );
        require(_to != address(0), "cant transfer to zero address");
        require(_balances[_id][_from] >= _value, "insufficient funds");

        _balances[_id][_from] -= _value;
        _balances[_id][_to] += _value;

        emit Transfer(msg.sender, _from, _to, _id, _value);
    }

    function setApprovalForAll(address _operator, bool _approved) public {
        require(msg.sender != _operator, "cant approve for caller");
        require(_operator != address(0), "cant approve for zero address");
        _operatorApprovals[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) public view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function mint(
        address _to,
        uint256 _tokenId,
        uint256 _value
    ) external onlyOwner {
        require(_to != address(0), "cant mint for 0 address");

        _balances[_tokenId][_to] += _value;
        emit Transfer(msg.sender, address(0), _to, _tokenId, _value);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }
}
