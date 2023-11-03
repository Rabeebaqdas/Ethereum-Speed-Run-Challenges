// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Monyo is ERC20 {
    constructor(address _multiSig, uint256 _amount) ERC20("Gold", "GLD") {
        _mint(_multiSig, _amount);
    }
}
