// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "./IUniswapV2Router02.sol";

abstract contract IContractsLibraryV3 {
    function BUSD() external view virtual returns (address);

    function WBNB() external view virtual returns (address);

    function ROUTER() external view virtual returns (IUniswapV2Router02);

    function getBusdToBNBToToken(
        address token,
        uint _amount
    ) external view virtual returns (uint256);

    function getTokensToBNBtoBusd(
        address token,
        uint _amount
    ) external view virtual returns (uint256);

    function getTokensToBnb(
        address token,
        uint _amount
    ) external view virtual returns (uint256);

    function getBnbToTokens(
        address token,
        uint _amount
    ) external view virtual returns (uint256);

    function getTokenToBnbToAltToken(
        address token,
        address altToken,
        uint _amount
    ) external view virtual returns (uint256);

    function getLpPrice(
        address token,
        uint _amount
    ) external view virtual returns (uint256);

    function getUsdToBnB(uint amount) external view virtual returns (uint256);

    function getBnbToUsd(uint amount) external view virtual returns (uint256);

    function getInForTokenToBnbToAltToken(address token, address altToken, uint _amount) external view virtual returns (uint256);
}
