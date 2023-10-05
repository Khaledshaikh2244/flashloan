// SPDX-License-Identifier: MIT

pragma solidity 0.8;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './FlashloanProvider.sol';
import './IFashloanUser.sol';

contract FlashloanUser is IFlashloanUser {
     function startFlashloan (address flashloan , uint amount , address token)
     external{FlashloanProvider (flashloan).executeFlashloan(
     address(this),
     amount,
     token,
     bytes('')); }
     function flashloanCallback (
     uint amount ,
     address token,
     bytes memory data )
     override
     external {
          //do some arbitrage , liquiditation ,
          //reimburse borrowed token
          IERC20(token).transfer(msg.sender ,  amount);
     }
} 