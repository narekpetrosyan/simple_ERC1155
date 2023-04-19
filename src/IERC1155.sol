// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IERC1155 {
    event Transfer(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    function transferFrom(
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _values
    ) external;

    function singleTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value
    ) external;

    function balanceOf(
        address _owner,
        uint256 _id
    ) external view returns (uint256);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool);
}
