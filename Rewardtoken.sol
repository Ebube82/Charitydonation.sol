// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract RewardToken is ERC20, Ownable {
    // Address where transaction fees are sent
    address public feeAddress;

    // Event emitted when the fee address is updated
    event FeeAddressUpdated(address newFeeAddress);

    // Constructor to initialize the token with a name and symbol
    constructor(string memory name, string memory symbol, address initialFeeAddress) ERC20(name, symbol) {
        feeAddress = initialFeeAddress;
    }

    // Function to mint new tokens; restricted to the contract owner
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    // Function to burn tokens; restricted to the contract owner
    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }

    // Function to update the fee address; restricted to the contract owner
    function setFeeAddress(address newFeeAddress) public onlyOwner {
        feeAddress = newFeeAddress;
        emit FeeAddressUpdated(newFeeAddress);
    }

    // Override the transfer function to include a fee deduction
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 fee = amount / 100; // 1% fee
        uint256 amountAfterFee = amount - fee;

        super._transfer(sender, feeAddress, fee); // Send fee to the fee address
        super._transfer(sender, recipient, amountAfterFee); // Transfer the remaining amount
    }
}
