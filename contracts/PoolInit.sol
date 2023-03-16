//SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

import "@aave/protocol-v2/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";

contract PoolInit {
    ILendingPoolAddressesProvider ADDRESS_PROVIDER;
    ILendingPool LENDING_POOL;

    constructor(address _provider) public {
        ADDRESS_PROVIDER = ILendingPoolAddressesProvider(_provider);
        LENDING_POOL = ILendingPool(ADDRESS_PROVIDER.getLendingPool());
    }
}
