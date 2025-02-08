# NFT Marketplace Smart Contract

This repository contains a **Solidity** smart contract for an NFT Marketplace that facilitates the sale of **ERC721** NFTs using an **ERC20** token as the payment method. The contract includes security measures to prevent front-running attacks and allows the marketplace owner to collect fees.

## 📌 Features

- Buy and sell **ERC721 NFTs** using **ERC20 tokens**.
- **Front-running protection** mechanism.
- **Sale management**: Open, cancel, and execute sales.
- **Commission system**: 5% of each transaction goes to the marketplace contract.
- **Funds withdrawal**: The contract owner can collect accumulated fees.

## 🚀 Technical Overview

This contract manages NFT transactions by locking assets during the sale process, ensuring a secure and trustless transaction system.

### 📜 Smart Contract Code Overview

The contract integrates **IERC721** and **IERC20** interfaces from OpenZeppelin for token standard compliance.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlace is Ownable (msg.sender) {
    IERC20 tokenERC20;
    IERC721 nft;

    enum SaleStatus { open, cancelled, executed }

    struct Sale {
        address owner;
        SaleStatus sale;
        uint256 price;
    }

    mapping(uint256 => Sale) sales;
    mapping(uint256 => uint256) security;
```

### 🔹 Key Functionalities

1. **Opening a Sale**
   - The NFT owner can list their NFT for sale by specifying a price.
   - The NFT is transferred to the contract until sold or canceled.

2. **Canceling a Sale**
   - The original seller can cancel an open sale.
   - The NFT is returned to the seller.

3. **Buying an NFT**
   - The buyer must pay the specified price in **ERC20 tokens**.
   - A **5% commission** is deducted and stored in the contract.
   - The NFT is transferred to the new owner.

4. **Withdrawing Fees**
   - The contract owner can withdraw accumulated **ERC20 token** commissions.

## ⚙️ Installation & Deployment

### 🔧 Requirements

- **Node.js** & **npm**
- **Hardhat** or **Remix IDE**
- **MetaMask** (or compatible Ethereum wallet)

### 📦 Setup

Clone this repository:

```sh
git clone https://github.com/your-username/nft-marketplace.git
cd nft-marketplace
```

Install dependencies:

```sh
npm install
```

### 🚀 Deployment

Deploy the contract using Hardhat or any Ethereum testnet:

```sh
npx hardhat run scripts/deploy.js --network goerli
```

## 🛠 Future Enhancements

- Implement **auction-based** NFT sales.
- Add **royalty support** for creators.
- Build a **frontend** to interact with the marketplace.

