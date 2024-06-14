# ETH-AVAX-Module-4

The DegenToken smart contract is a Solidity implementation for a custom ERC-20 token and related functionalities designed for a decentralized gaming platform or application. This contract allows players to earn, stake, redeem, and trade tokens within the game ecosystem. Additionally, players can use their tokens to purchase in-game goodies from the store.

## Description
### Features

Minting: The contract owner can mint new tokens and distribute them to specific addresses.
Transferring Tokens: Players can transfer their tokens to other addresses.
Redeeming Tokens: Players can redeem their tokens for in-game items available in the store.
Burning Tokens: Anyone can burn their owned tokens that are no longer needed.
Transfer Items: Players can transfer their in-game items to other players.

## Getting Started

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the left-hand sidebar. Save the file with a .sol extension (e.g., DeganToken.sol). Copy and paste the code from the contract into the file.

code look like this
```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DeganToken is ERC20, Ownable {
    string[] public sportsItems;

    constructor() ERC20("Degan", "DGN") Ownable(msg.sender) {
        sportsItems.push("CricketBat");
        sportsItems.push("CricketPad");
        sportsItems.push("CricketHelmet");
        sportsItems.push("CricketBall");
    }

    function mintTokens(address recipient, uint256 amount) external onlyOwner {
        _mint(recipient, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        return super.transfer(recipient, amount);
    }

    function redeemToken(uint256 itemId, uint256 amount) public payable {
        require(itemId < sportsItems.length, "Item does not exist");
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");
        // Logic for redeeming items
    }

    function burnTokens(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transferItems(address to, uint256 itemId) public {
        require(itemId < sportsItems.length, "Item does not exist");
        _transfer(_msgSender(), to, itemId);
    }

    function checkTokenBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }
}

```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to graater than 0.8.0, and then click on the "Compile DeganToken.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar.
In environment you have to inject your metamask and metamask must be connected with fuji testnet.
Select the "deganToken" contract from the dropdown menu, and then click on the "Deploy" button.

With this approach, you can configure Metamask to interact with Avalanche networks such as Fuji Testnet or Avalanche Mainnet.
1. Install Metamask: If you don't have Metamask installed in your browser, you can download and install it from the official [Metamask website](https://metamask.io/)
2. Configure Avalanche Network:
Open Metamask in your browser.
Click on the Metamask icon and then click on the network selection dropdown (it will likely display "Ethereum Mainnet" by default).
At the bottom of the list, click on "Custom RPC."
3. Fill in Avalanche Network Details:
In the "Custom RPC" section, you will need to provide the Avalanche network details. For example, for Avalanche Fuji Testnet, you can use the following details:
Network Name: Avalanche Fuji Testnet
New RPC URL: https://api.avax-test.network/ext/bc/C/rpc
ChainID: 43113
Symbol: AVAX
Block Explorer URL: https://cchain.explorer.avax-test.network/
4. Save and Connect: After filling in the network details, click "Save" to add the custom Avalanche network to Metamask. You should now see the network selected in the dropdown.
5. Switch to Avalanche Network: To interact with Avalanche, make sure you have selected the Avalanche network in Metamask from the dropdown.

Once the contract is deployed, you can interact with it by calling the the following functions: mint function, redeem function and transfer etc. To functionality you have to give balances value.

## Authors

ABHIGYAN PUSHKAR


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
