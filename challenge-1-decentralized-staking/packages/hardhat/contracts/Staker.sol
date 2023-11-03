// SPDX-License-Identifier: MIT
pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading

// import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
	ExampleExternalContract public exampleExternalContract;
	mapping(address => uint256) public balances;
	uint256 public constant threshold = 1 ether;
	uint256 public deadline;
	bool public openForWithdraw = false;
	event Stake(address _user, uint256 _amount);

	constructor(address exampleExternalContractAddress) {
		deadline = block.timestamp + 72 hours;
		exampleExternalContract = ExampleExternalContract(
			exampleExternalContractAddress
		);
	}

	modifier notCompleted() {
		require(
			!exampleExternalContract.completed(),
			"external contract completed"
		);
		_;
	}

	function stake() public payable {
		require(msg.value > 0, "Insufficient Funds");
		balances[msg.sender] += msg.value;
		emit Stake(msg.sender, msg.value);
	}

	function execute() public notCompleted {
		uint256 _timeLeft = timeLeft();
		require(_timeLeft == 0, "deadline still not met");

		if (address(this).balance >= threshold) {
			exampleExternalContract.complete{ value: address(this).balance }();
		} else {
			openForWithdraw = true;
		}
	}

	function withdraw() external notCompleted {
		require(openForWithdraw, "openForWithdraw closed");
		uint256 amountToBeWithdraw = balances[msg.sender];
		require(amountToBeWithdraw > 0, "Not Enough Funds");
		balances[msg.sender] = 0;
		(bool sent, ) = payable(msg.sender).call{ value: amountToBeWithdraw }(
			""
		);
		require(sent);
	}

	function timeLeft() public view returns (uint256) {
		if (block.timestamp > deadline) {
			return 0;
		} else {
			return deadline - block.timestamp;
		}
	}

	receive() external payable {
		stake();
	}
}
