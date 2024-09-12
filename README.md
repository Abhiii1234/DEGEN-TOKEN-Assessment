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
