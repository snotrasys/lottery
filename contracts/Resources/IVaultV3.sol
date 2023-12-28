// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IVaultV3 {
    function safeTransferToken(address from, address to, uint amount) external;

    function safeTransfer(address _to, uint _value) external;

    function getTokenAddressBalance(address token) external view returns (uint);

    function getTokenBalance(address token) external view returns (uint);

    function getBalance() external view returns (uint);

    function safeTransferAdmin(address from, address to, uint amount) external;

    function safeTransferAdmin(address _to, uint _value) external;

    function deposit(address from, uint amount) external;

    function EmitDeposit(address from, uint amount) external;

    event Deposit(address indexed from, uint amount);
}
