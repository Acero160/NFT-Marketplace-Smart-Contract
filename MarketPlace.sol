// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlace is Ownable (msg.sender) {

    //Variables
    IERC20 tokenERC20;
    IERC721 nft;

    enum SaleStatus {
        open, cancelled, executed
    }

    struct Sale {
        address owner;
        SaleStatus sale;
        uint256 price;
    }

    //Mappings
    mapping(uint256=>Sale) sales;
    mapping(uint256=>uint256) security;

    modifier frontRunning(uint256 _nftID) {
        require(
            security [_nftID] == 0 ||
            security[_nftID] < block.number, "Security error"
        );

        security[_nftID] = block.number;
        _;
    }


    constructor (address _tokenERC20, address _nfts) {
        tokenERC20 = IERC20(_tokenERC20);
        nft = IERC721(_nfts);
    }

    //Functions

    function openSale (uint256 _nftID, uint256 _price) public frontRunning(_nftID) {
        require (msg.sender == nft.ownerOf(_nftID), "You dont have permissions");
        nft.transferFrom(msg.sender, address(this), _nftID);

        sales[_nftID] = Sale(msg.sender, SaleStatus.open, _price);
    }

    function cancelSale (uint256 _nftID) public frontRunning(_nftID) {
        require (msg.sender == sales [_nftID].owner, "You dont have permissions");
        require(sales[_nftID].sale == SaleStatus.open, "SOLD");

        sales[_nftID].sale = SaleStatus.cancelled;

        nft.transferFrom(address(this), msg.sender, _nftID);
    }

    function buyTokens (uint256 _nftID) public frontRunning(_nftID) {
        require(sales[_nftID].sale == SaleStatus.open, "Is not open");
        require(tokenERC20.transferFrom(msg.sender, sales[_nftID].owner,  sales[_nftID].price));
        // This contract takes 5% of the token as a commission/fee.
        require(tokenERC20.transferFrom(msg.sender, address(this),  sales[_nftID].price*5/100));

        nft.transferFrom(sales[_nftID].owner, msg.sender, _nftID);

        sales[_nftID].owner = msg.sender;
        sales[_nftID].sale = SaleStatus.executed;
    }

    function getFees () public onlyOwner {
        require(tokenERC20.transfer(msg.sender, tokenERC20.balanceOf(address(this))), "Error transferring token");
    }
}
