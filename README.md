# DEGEN TOKEN CONTRACT

The DegenToken smart contract is a Solidity implementation for a custom ERC-20 token and related functionalities designed for a decentralized gaming platform or application. This contract allows players to earn, stake, redeem, and trade tokens within the game ecosystem. Additionally, players can use their tokens to purchase in-game goodies from the store.

## Description
### Features

- **Minting**: The contract owner can mint new tokens and distribute them to specific addresses.
- **Transferring Tokens**: Players can transfer their tokens to other addresses.
- **Redeeming Tokens**: Players can redeem their tokens for in-game items available in the store.
- **Burning Tokens**: Anyone can burn their owned tokens that are no longer needed.
- **Staking Tokens**: Players can stake their tokens to earn rewards.
- **Claiming Rewards**: Players can claim their earned staking rewards.
- **Transfer Items**: Players can transfer their in-game items to other players.

## Getting Started

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the left-hand sidebar. Save the file with a .sol extension (e.g., DegenToken.sol). Copy and paste the code from the contract into the file.

The code looks like this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
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
```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to greater than 0.8.0, and then click on the "Compile DegenToken.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar.
In environment, you have to inject your MetaMask, and MetaMask must be connected with Fuji testnet.
Select the "DegenToken" contract from the dropdown menu, and then click on the "Deploy" button.

With this approach, you can configure MetaMask to interact with Avalanche networks such as Fuji Testnet or Avalanche Mainnet.
1. **Install MetaMask**: If you don't have MetaMask installed in your browser, you can download and install it from the official [MetaMask website](https://metamask.io/)
2. **Configure Avalanche Network**:
   - Open MetaMask in your browser.
   - Click on the MetaMask icon and then click on the network selection dropdown (it will likely display "Ethereum Mainnet" by default).
   - At the bottom of the list, click on "Custom RPC."
3. **Fill in Avalanche Network Details**:
   - In the "Custom RPC" section, you will need to provide the Avalanche network details. For example, for Avalanche Fuji Testnet, you can use the following details:
     - Network Name: Avalanche Fuji Testnet
     - New RPC URL: https://api.avax-test.network/ext/bc/C/rpc
     - ChainID: 43113
     - Symbol: AVAX
     - Block Explorer URL: https://cchain.explorer.avax-test.network/
4. **Save and Connect**: After filling in the network details, click "Save" to add the custom Avalanche network to MetaMask. You should now see the network selected in the dropdown.
5. **Switch to Avalanche Network**: To interact with Avalanche, make sure you have selected the Avalanche network in MetaMask from the dropdown.

Once the contract is deployed, you can interact with it by calling the following functions: mint function, redeem function, transfer, etc. To use the functionality, you have to give balances value.

## Authors

ABHIGYAN PUSHKAR

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
