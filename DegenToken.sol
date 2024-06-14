// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DeganToken is ERC20, Ownable {
    string[] public sportsItems;

    constructor(address initialOwner) ERC20("Degan", "DGN") Ownable(initialOwner) {
        sportsItems.push("CricketBat");
        sportsItems.push("CricketPad");
        sportsItems.push("CricketHelmet");
        sportsItems.push("CricketBall");
    }

    function mintTokens(address recipient, uint256 amount) external onlyOwner {
        _mint(recipient, amount);
    }

    // Transferring tokens: Players can transfer their tokens to others.
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        return super.transfer(recipient, amount);
    }

    // Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
    function redeemTokens(uint256 itemId, uint256 amount) public payable {
        require(itemId < sportsItems.length, "Item does not exist");
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");
    }

    function checkTokenBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    // Burning tokens: Anyone should be able to burn tokens that they own and are no longer needed.
    function burnTokens(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Transfer items: Players should be able to transfer their in-game items.
    function transferItems(address to, uint256 itemId) public {
        require(itemId < sportsItems.length, "Item does not exist");
        _transfer(_msgSender(), to, itemId);
    }
}

