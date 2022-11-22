// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // events
    event SubmissionCreated(string title, string description);
    event Vote(uint256 submissionId);
    event Unvote(uint256 submissionId);

    // submission object
    struct Submission {
        uint256 id;
        string title;
        string description;
        uint256 voteCount;
    }

    mapping(uint256 => Submission) public submissions;

    uint256 public submissionCount;

    // address of users who have voted
    mapping(address => bool) public isVoter;

    // allows only owners call a function
    modifier onlyOwner() {
        require(owner == msg.sender, "Not the owner");
        _;
    }

    /**
     @dev add a new submission
     @param _title submission title
     @param _title submission description
    */
    function addSubmission(string memory _title, string memory _description)
        external
        onlyOwner
    {
        submissionCount++;
        Submission memory newSubmission = Submission(
            submissionCount,
            _title,
            _description,
            0
        );
        submissions[submissionCount] = newSubmission;

        emit SubmissionCreated(_title, _description);
    }

    /**
     @dev view all submissions
     @param _submissionId the id of the submission
    */
    function viewSubmission(uint256 _submissionId)
        external
        view
        returns (Submission memory submission)
    {
        return submissions[_submissionId];
    }

    /**
     @dev vote for submissions
     @param _submissionId the id of the submission
    */
    function vote(uint256 _submissionId) external {
        // prevent double voting
        require(!isVoter[msg.sender], "You cannot vote twice");

        // record voting
        isVoter[msg.sender] = true;

        // increase submission vote count
        submissions[_submissionId].voteCount++;

        // emit
        emit Vote(_submissionId);
    }

    /**
     @dev remove vote
     @param _submissionId the id of the submission
    */
    function unvote(uint256 _submissionId) external {
        // prevent double voting
        require(isVoter[msg.sender], "You have not voted");

        // record voting
        isVoter[msg.sender] = false;

        // decrease submission vote count
        submissions[_submissionId].voteCount--;

        // emit event
        emit Unvote(_submissionId);
    }

    /**
     @dev display vote by id
     @param _submissionId the id of the submission
    */
    function viewVotes(uint256 _submissionId) public view returns (uint256) {
        return submissions[_submissionId].voteCount;
    }
}
