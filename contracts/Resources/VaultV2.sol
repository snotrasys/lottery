// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IVaultV2.sol";

contract VaultV2 is Ownable, IVaultV2 {
    address public admin;

    // constructor() Ownable(msg.sender) {
    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin");
        _;
    }

    function safeTransfer(IERC20 from, address to, uint amount) external override onlyOwner {
        from.transfer(to, amount);
    }

    function safeTransfer(address _to, uint _value) external override onlyOwner {
        payable(_to).transfer(_value);
    }


    function safeTransferAdmin(address from, address to, uint amount) external override onlyAdmin {
        IERC20(from).transfer(to, amount);
    }

    function safeTransferAdmin(address _to, uint _value) external override onlyAdmin {
        payable(_to).transfer(_value);
    }

    function getTokenAddressBalance(address token) external view override returns (uint) {
        return IERC20(token).balanceOf(address(this));
    }

    function getTokenBalance(IERC20 token) external view override returns (uint) {
        return token.balanceOf(address(this));
    }

    function getBalance() external view override returns (uint) {
        return address(this).balance;
    }

    fallback() external payable {
    }

    receive() external payable {
    }

}
