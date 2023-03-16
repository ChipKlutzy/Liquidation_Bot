//SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

import "./PoolInit.sol";
import "./interfaces/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";

contract LiquidationBot is PoolInit {
    address private owner;

    IUniswapV2Router01 Router01;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an Owner");
        _;
    }

    constructor(address _provider, address _router) public PoolInit(_provider) {
        owner = payable(msg.sender);
        Router01 = IUniswapV2Router01(_router);
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        (
            address collateral,
            address user,
            uint256 amountOutMin,
            address[] memory swapPath
        ) = abi.decode(params, (address, address, uint256, address[]));

        liquidateLoan(collateral, assets[0], user, amounts[0], false);

        SwapTokens(collateral, amountOutMin, swapPath);

        uint256 profit = calProfits(
            IERC20(assets[0]).balanceOf(address(this)),
            amounts[0],
            premiums[0]
        );

        require(profit > 0, "This Liquidation is a Non-Profit Transaction :( ");

        uint amountOwing = amounts[0] + premiums[0];
        IERC20(assets[0]).approve(address(LENDING_POOL), amountOwing);

        return true;
    }

    function calProfits(
        uint256 balance,
        uint256 loanAmount,
        uint256 loanfee
    ) private pure returns (uint256) {
        return (balance - loanAmount + loanfee);
    }

    function liquidateLoan(
        address _collateral,
        address _debt,
        address _user,
        uint256 _amount,
        bool _receiveAtokens
    ) public {
        require(
            IERC20(_debt).approve(address(LENDING_POOL), _amount),
            "LENDING POOL Approval failed"
        );

        LENDING_POOL.liquidationCall(
            _collateral,
            _debt,
            _user,
            _amount,
            _receiveAtokens
        );
    }

    function SwapTokens(
        address tokenIn,
        uint256 amountOutMin,
        address[] memory swapPath
    ) public {
        uint deadline = block.timestamp + 60 seconds;

        uint amountIn = IERC20(tokenIn).balanceOf(address(this));

        require(
            IERC20(tokenIn).approve(address(Router01), amountIn),
            "Uniswap Router Approval Failed"
        );

        Router01.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            swapPath,
            address(this),
            deadline
        );
    }

    // This is an external function which initiates our Liquidation flashLoan
    function letsParty(
        address DebtAsset,
        uint256 FlashloanAmt,
        address collateral,
        address user,
        uint256 amountOutmin,
        address[] memory swapPath
    ) public onlyOwner {
        address receiverAddress = address(this);

        address[] memory assets = new address[](1);
        assets[0] = DebtAsset;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = FlashloanAmt;

        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);

        bytes memory params = abi.encode(
            collateral,
            user,
            amountOutmin,
            swapPath
        );
        uint16 referralCode = 0;

        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }
}
