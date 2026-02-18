// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollingSystem {

    struct Poll {
        string title;
        string[] options;
        uint256 endTime;
        mapping(uint256 => uint256) votes;   // option index => vote count
        mapping(address => bool) hasVoted;   // track voters
        bool exists;
    }

    uint256 public pollCount;
    mapping(uint256 => Poll) private polls;

    function createPoll(
        string memory _title,
        string[] memory _options,
        uint256 _durationInMinutes
    ) public {

        require(_options.length > 1, "At least 2 options required");

        Poll storage newPoll = polls[pollCount];

        newPoll.title = _title;
        newPoll.options = _options;
        newPoll.endTime = block.timestamp + (_durationInMinutes * 1 minutes);
        newPoll.exists = true;

        pollCount++;
    }

    function vote(uint256 _pollId, uint256 _optionIndex) public {

        Poll storage poll = polls[_pollId];

        require(poll.exists, "Poll does not exist");
        require(block.timestamp < poll.endTime, "Voting ended");
        require(!poll.hasVoted[msg.sender], "Already voted");
        require(_optionIndex < poll.options.length, "Invalid option");

        poll.votes[_optionIndex]++;
        poll.hasVoted[msg.sender] = true;
    }

    function getWinner(uint256 _pollId)
        public
        view
        returns (string memory winner)
    {
        Poll storage poll = polls[_pollId];

        require(poll.exists, "Poll does not exist");
        require(block.timestamp >= poll.endTime, "Poll still active");

        uint256 winningVoteCount = 0;
        uint256 winningIndex = 0;

        for (uint256 i = 0; i < poll.options.length; i++) {
            if (poll.votes[i] > winningVoteCount) {
                winningVoteCount = poll.votes[i];
                winningIndex = i;
            }
        }

        winner = poll.options[winningIndex];
    }
}
