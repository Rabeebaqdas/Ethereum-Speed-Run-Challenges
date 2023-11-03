pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vendor is Ownable {
	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
	uint256 public constant tokensPerEth = 100;
	IERC20 public yourToken;

	constructor(address tokenAddress) Ownable() {
		yourToken = IERC20(tokenAddress);
	}

	// ToDo: create a payable buyTokens() function:
	function buyTokens() external payable {
		uint256 userAmount = msg.value;
		require(userAmount > 0, "Insufficient funds");
		uint256 tokenAmountToBeTransfer = userAmount * tokensPerEth;
		yourToken.transfer(msg.sender, tokenAmountToBeTransfer);

		emit BuyTokens(msg.sender, userAmount, tokenAmountToBeTransfer);
	}

	// ToDo: create a withdraw() function that lets the owner withdraw ETH
	function withdraw() external onlyOwner {
		(bool sent, ) = payable(msg.sender).call{
			value: address(this).balance
		}("");
		require(sent);
	}

	// ToDo: create a sellTokens(uint256 _amount) function:
	function sellTokens(uint256 _tokenAmount) external {
		uint256 tokenAmount = _tokenAmount;
		require(tokenAmount > 0, "Insufficient token amount");
		yourToken.transferFrom(msg.sender, address(this), tokenAmount);
		uint256 userAmountToBeTransfer = tokenAmount / tokensPerEth;
		// require(address(this).balance >= userAmountToBeTransfer , "Insufficient funds in contract"); to be added
		(bool sent, ) = payable(msg.sender).call{
			value: userAmountToBeTransfer
		}("");
		require(sent);
	}
}
