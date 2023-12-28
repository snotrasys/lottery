// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IVaultV3.sol";
import  "./IVaultReceiverV2.sol";
// staking bills
contract VaultV3 is Ownable, IVaultV3 {
    address public admin;

    // constructor() Ownable(msg.sender) {
    constructor() {
        admin = msg.sender;
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(supportsERC165InterfaceUnchecked(newOwner, type(IVaultReceiverV2).interfaceId) &&
            IVaultReceiverV2(newOwner).vault() == address(this), "not a vault receiver");
        super.transferOwnership(newOwner);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin");
        _;
    }

    function safeTransferToken(address from, address to, uint amount) external override onlyOwner {
        IERC20(from).transfer(to, amount);
    }

    function safeTransfer(address _to, uint _value) external override onlyOwner {
        payable(_to).transfer(_value);
    }

    function deposit(address from, uint amount) external override onlyOwner {
        IERC20(from).transferFrom(msg.sender, address(this), amount);
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

    function getTokenBalance(address token) external view override returns (uint) {
        return IERC20(token).balanceOf(address(this));
    }

    function getBalance() external view override returns (uint) {
        return address(this).balance;
    }

    fallback() external payable {}

    receive() external payable {}

    function supportsERC165InterfaceUnchecked(address account, bytes4 interfaceId) internal view returns (bool) {
        // prepare call
        bytes memory encodedParams = abi.encodeCall(IVaultReceiverV2.supportsInterface, interfaceId);

        // perform static call
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly {
            success := staticcall(30000, account, add(encodedParams, 0x20), mload(encodedParams), 0x00, 0x20)
            returnSize := returndatasize()
            returnValue := mload(0x00)
        }

        return success && returnSize >= 0x20 && returnValue > 0;
    }

    function EmitDeposit(address from, uint amount) external override onlyOwner {
        emit Deposit(from, amount);
    }

}
