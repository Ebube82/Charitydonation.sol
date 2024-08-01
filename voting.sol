// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Voting {
    address public administrator;
    mapping(address => bool) public hasVoted;
    mapping(string => uint256) public votesReceived;
    string[] public candidateList;

    constructor() {
        administrator = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == administrator, "Only the administrator can perform this action.");
        _;
    }

    function addCandidate(string memory candidateName) public onlyAdmin {
        candidateList.push(candidateName);
    }

    function vote(string memory candidateName) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(isValidCandidate(candidateName), "Invalid candidate.");
        votesReceived[candidateName]++;
        hasVoted[msg.sender] = true;
    }

    function getVotes(string memory candidateName) public view returns (uint256) {
        return votesReceived[candidateName];
    }

    function getCandidates() public view returns (string[] memory) {
        return candidateList;
    }

    function getWinner() public view returns (string memory winnerName) {
        uint256 highestVoteCount = 0;
        for (uint256 i = 0; i < candidateList.length; i++) {
            string memory candidateName = candidateList[i];
            uint256 candidateVoteCount = votesReceived[candidateName];
            if (candidateVoteCount > highestVoteCount) {
                highestVoteCount = candidateVoteCount;
                winnerName = candidateName;
            }
        }
    }

    function isValidCandidate(string memory candidateName) internal view returns (bool) {
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (keccak256(abi.encodePacked(candidateList[i])) == keccak256(abi.encodePacked(candidateName))) {
                return true;
            }
        }
        return false;
    }
}
