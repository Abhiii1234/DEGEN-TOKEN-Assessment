// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable(msg.sender) {
    mapping(address => uint256) private stakedBalances;
    mapping(address => uint256) private goodiesInventory;
    uint256 public rewardRate; // Reward rate in tokens per block
    uint256 public lastUpdateBlock;

    event GoodiePurchased(address indexed buyer, uint256 amount);

    constructor() ERC20("Degen", "DGN") {
        _mint(msg.sender, 0); // Mint initial supply to the contract deployer
        rewardRate = 1; // 1 token reward per block (you can adjust this as needed)
        lastUpdateBlock = block.number;
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    // Minting new tokens: The owner can create and distribute new tokens to players as rewards.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transferring tokens: Players can transfer their tokens to others.
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        return super.transfer(to, amount);
    }

    // Redeeming tokens: Players can redeem their tokens for items in the in-game store.
    function redeem(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Not enough balance to redeem");

        goodiesInventory[msg.sender] += amount;
        _burn(msg.sender, amount);
    }

    // Checking token balance: Players can check their token balance at any time.
    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account);
    }

    // Burning tokens: Anyone can call this function to burn tokens they own, that are no longer needed.
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Player can stake tokens to earn rewards.
    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Not enough balance to stake");

        // Calculate rewards for previous staking period and transfer them to the staker
        updateRewards();
        uint256 rewards = stakedBalances[msg.sender] * (block.number - lastUpdateBlock) * rewardRate;
        stakedBalances[msg.sender] += amount;
        lastUpdateBlock = block.number;
        _transfer(msg.sender, address(this), amount);
        _mint(msg.sender, rewards);
    }

    // Player can claim their earned rewards.
    function getReward() public {
        updateRewards();
        uint256 rewards = stakedBalances[msg.sender] * (block.number - lastUpdateBlock) * rewardRate;
        lastUpdateBlock = block.number;
        _mint(msg.sender, rewards);
    }

    // Internal function to update rewards for a staker
    function updateRewards() internal {
        uint256 rewards = stakedBalances[msg.sender] * (block.number - lastUpdateBlock) * rewardRate;
        _mint(msg.sender, rewards);
    }

    // Game store: Players can use their redeemed tokens to buy goodies
    function buyGoodies(uint256 amount) public {
        require(goodiesInventory[msg.sender] >= amount, "Not enough goodies inventory");
        goodiesInventory[msg.sender] -= amount;
        // Implement the logic for providing the goodies to the player
        emit GoodiePurchased(msg.sender, amount);
    }

    // Function to check the available goodies inventory for a player
    function getGoodiesInventory() public view returns (uint256) {
        return goodiesInventory[msg.sender];
    }
}
