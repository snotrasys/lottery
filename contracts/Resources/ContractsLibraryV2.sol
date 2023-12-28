// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IContractsLibraryV2.sol";
import "./IUniswapV2Pair.sol";

contract ContractsLibraryV2 is AccessControl, IContractsLibraryV2 {
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    // 0x55d398326f99059fF775485246999027B3197955 is usdt 
    address public BUSD_MAIN =
        address(0x55d398326f99059fF775485246999027B3197955);
    address public BUSD_TEST =
        address(0x258Aa11629a80e888740ba84114b71BCa8d07dF7);
    address public WBNB_MAIN =
        address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    address public WBNB_TEST =
        address(0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd);
    address public ROUTER_MAIN =
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    address public ROUTER_TEST =
        address(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
    address public FACTORY_TEST =
        address(0x6725F303b657a9451d8BA641348b6761A6CC7a17);
    address public FACTORY_MAIN =
        address(0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73);

    modifier onlyOwners() {
        require(hasRole(OWNER_ROLE, _msgSender()), "Only owner");
        _;
    }

    constructor() {
        _grantRole(OWNER_ROLE, msg.sender);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
    }

    function setBusdAddress(
        address _address,
        bool _isTest
    ) external virtual onlyOwners {
        if (_isTest) {
            BUSD_TEST = _address;
        } else {
            BUSD_MAIN = _address;
        }
    }

    function setWbnbAddress(
        address _address,
        bool _isTest
    ) external virtual onlyOwners {
        if (_isTest) {
            WBNB_TEST = _address;
        } else {
            WBNB_MAIN = _address;
        }
    }

    function setRouterAddress(
        address _address,
        bool _isTest
    ) external onlyOwners {
        if (_isTest) {
            ROUTER_TEST = _address;
        } else {
            ROUTER_MAIN = _address;
        }
    }

    function getChainId() external view returns (uint256) {
        return block.chainid;
    }

    function BUSD() public view override returns (address) {
        if (block.chainid == 56) return BUSD_MAIN;
        else return BUSD_TEST;
    }

    function WBNB() public view override returns (address) {
        if (block.chainid == 56) return WBNB_MAIN;
        else return WBNB_TEST;
    }

    function ROUTER() public view override returns (IUniswapV2Router02) {
        if (block.chainid == 56) return IUniswapV2Router02(ROUTER_MAIN);
        else return IUniswapV2Router02(ROUTER_TEST);
    }

    function getBusdToBNBToToken(
        address token,
        uint _amount
    ) public view override returns (uint256) {
        address[] memory _addressArray = new address[](3);
        _addressArray[0] = BUSD();
        _addressArray[1] = WBNB();
        _addressArray[2] = token;
        uint[] memory _amounts = ROUTER().getAmountsOut(_amount, _addressArray);
        return _amounts[_amounts.length - 1];
    }

    function getTokensToBNBtoBusd(
        address token,
        uint _amount
    ) public view override returns (uint256) {
        address[] memory _addressArray = new address[](3);
        _addressArray[0] = token;
        _addressArray[1] = WBNB();
        _addressArray[2] = BUSD();
        uint[] memory _amounts = ROUTER().getAmountsOut(_amount, _addressArray);
        return _amounts[_amounts.length - 1];
    }

    function getTokensToBnb(
        address token,
        uint _amount
    ) public view override returns (uint256) {
        address[] memory _addressArray = new address[](2);
        _addressArray[0] = token;
        _addressArray[1] = WBNB();
        uint[] memory _amounts = ROUTER().getAmountsOut(_amount, _addressArray);
        return _amounts[_amounts.length - 1];
    }

    function getBnbToTokens(
        address token,
        uint _amount
    ) public view override returns (uint256) {
        address[] memory _addressArray = new address[](2);
        _addressArray[0] = WBNB();
        _addressArray[1] = token;
        uint[] memory _amounts = ROUTER().getAmountsOut(_amount, _addressArray);
        return _amounts[_amounts.length - 1];
    }

    function getTokenToBnbToAltToken(
        address token,
        address altToken,
        uint _amount
    ) public view override returns (uint256) {        
        address[] memory _addressArray = new address[](3);
        _addressArray[0] = token;
        _addressArray[1] = WBNB();
        _addressArray[2] = altToken;
        uint[] memory _amounts = ROUTER().getAmountsOut(_amount, _addressArray);
        return _amounts[_amounts.length - 1];
    }

    function getLpPrice(
        address _token,
        uint _amount
    ) public view override returns (uint) {
        IUniswapV2Pair pair = IUniswapV2Pair(_token);
        uint totalSupply = pair.totalSupply();
        address token0 = pair.token0();
        address token1 = pair.token1();
        uint value0 = 0;
        uint value1 = 0;
        (uint Res0, uint Res1, ) = pair.getReserves();
        if (token0 == WBNB()) {
            value0 = getBnbToTokens(BUSD(), 1 ether);
        } else {
            if (token0 == BUSD()) {
                value0 = 1 ether;
            } else {
                value0 = getTokensToBNBtoBusd(token0, 1 ether);
            }
        }
        if (token1 == WBNB()) {
            value1 = getBnbToTokens(BUSD(), 1 ether);
        } else {
            if (token1 == BUSD()) {
                value1 = 1 ether;
            } else {
                value1 = getTokensToBNBtoBusd(token1, 1 ether);
            }
        }
        return
            (((value0 * Res0) + (value1 * Res1)) * _amount) /
            (totalSupply * 1 ether);
    }

    function getUsdToBnB(uint amount) external view override returns (uint256) {
        address[] memory _addressArray = new address[](2);
        _addressArray[0] = BUSD();
        _addressArray[1] = WBNB();
        uint[] memory _amounts = ROUTER().getAmountsOut(amount, _addressArray);
        return _amounts[_amounts.length - 1];
    }

    function getBnbToUsd(uint amount) external view override returns (uint256) {
        address[] memory _addressArray = new address[](2);
        _addressArray[0] = WBNB();
        _addressArray[1] = BUSD();
        uint[] memory _amounts = ROUTER().getAmountsOut(amount, _addressArray);
        return _amounts[_amounts.length - 1];
    }
}
