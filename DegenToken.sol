// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is ERC20 {

    address public owner;

    // Mapping to store item costs
    mapping(uint => uint) public itemCosts;

    // Mapping to store redeemed items for each player
    mapping(address => uint[]) public redeemedItems;

    constructor() ERC20("Degen", "DGN") {
        owner = msg.sender;
        itemCosts[1] = 100;
        itemCosts[2] = 200;
        itemCosts[3] = 300;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    event Redeemed(address indexed account, uint itemNo, uint256 amount);

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint amount) public {
        _burn(msg.sender, amount);
    }

    function redeem(uint itemNo) public {
        uint256 amount = itemCosts[itemNo];
        require(amount > 0, "Invalid item number");
        _burn(msg.sender, amount);
        
        // Deliver the item to the player
        redeemedItems[msg.sender].push(itemNo);
        
        emit Redeemed(msg.sender, itemNo, amount);
    }

    function transfer(address to, uint amount) public override returns(bool){
        _transfer(msg.sender, to, amount);
        return true;
    }

    // Function to get the redeemed items of a player
    function getRedeemedItems(address player) public view returns (uint[] memory) {
        return redeemedItems[player];
    }
}
