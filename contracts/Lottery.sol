// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Lottery {
    
    uint public ticketPrice;
    uint public maxNumberOfTickets;
    uint public maxAmountAllowed;
    // equal to 95% of Total balance
    uint public lotteryPool;
    // equal to 5% of Total balance
    uint public usageFees;
    address public manager;
    address payable[] public players;
    
    constructor() {
        manager = msg.sender;
        ticketPrice = 20;
        maxNumberOfTickets = 10;
        maxAmountAllowed = ticketPrice * maxNumberOfTickets; 
    }

    function buyTicket() public payable {
        // Requirement: 
        // https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
        // TODO that MOK is created by you (you may use openzeppelin to create it).
        // 1 ERC-20 = 1 ETH

        require(msg.value > 0 ether);
        require(msg.value <= maxAmountAllowed);
        // only multiple of 20 allowed
        require(msg.value % ticketPrice == 0);

        lotteryPool = lotteryPool + ((msg.value * 95) / 100);
        usageFees = usageFees + ((msg.value * 5) / 100);
        
        players.push(payable(msg.sender));
    }    

    function getCurrentBalance() public view returns (uint) {
        //return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
        return address(this).balance;
    }

    function getCurrentLotteryPool() public view returns (uint) {
        //return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
        return lotteryPool;
    }

    function getCurrentFees() public view returns (uint) {
        //return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
        return usageFees;
    }

    // function enter() public payable {
    //     // Requirement: 
    //     // https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
    //     // TODO that MOK is created by you (you may use openzeppelin to create it).
    //     // 1 ERC-20 = 1 ETH

    //     require(msg.value > .01 ether);
    //     players.push(payable(msg.sender));
    // }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
    
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}   