// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IVaultReceiverV2 {
    function vault() external view returns (address);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
