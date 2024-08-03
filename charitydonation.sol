// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CharityDonation {
    // State variables
    address public admin;
    uint256 public totalDonations;

    // Event for donation
    event DonationReceived(address donor, uint256 amount);

    // Event for withdrawal
    event FundsWithdrawn(address admin, uint256 amount);

    // Event for admin transfer
    event AdminTransferred(address oldAdmin, address newAdmin);

    // Constructor to set the initial admin
    constructor() {
        admin = msg.sender;
    }

    // Modifier to restrict access to the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Function to donate to charity
    function donate() external payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    // Function to check the balance of the charity fund
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function to withdraw funds from the charity fund
    function withdraw(uint256 amount) external onlyAdmin {
        require(amount <= address(this).balance, "Insufficient funds");
        payable(admin).transfer(amount);
        totalDonations -= amount;
        emit FundsWithdrawn(admin, amount);
    }

    // Function to transfer admin rights
    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "New admin address cannot be zero");
        address oldAdmin = admin;
        admin = newAdmin;
        emit AdminTransferred(oldAdmin, newAdmin);
    }
}
