// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.26;

contract Twitter{

    uint16 public MAX_TWEET_LENGTH = 280;
    //author content timestamps likes
    struct Tweet{
        uint256 id;
        address author;
        string content;
        uint256 timestamps;
        uint256 likes;
     }

    mapping(address => Tweet[]) public tweets;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner{
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        require( bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long!");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamps: block.timestamp,
            likes: 0
        }); 
        tweets[msg.sender].push(newTweet);

    }
    
    function likeTweet(address _author, uint256 _id) external {
        require(tweets[_author][_id].id == _id, "Tweet does not exist!");
        tweets[_author][_id].likes++;

    }

    function unlikeTweet(address _author, uint256 _id) external {
        require(tweets[_author][_id].id == _id, "Tweet does not exist!");
        require(tweets[_author][_id].likes > 0, "Tweet has no likes");
        tweets[_author][_id].likes--;
    }

    function getTweet(uint _i) public view returns (Tweet memory){
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];
    }
}