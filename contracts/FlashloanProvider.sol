// SPDX-License-Identifier: MIT

pragma solidity 0.8;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import  './IFashloanUser.sol';

contract FlashloanProvider is ReentrancyGuard {
    mapping (address=>IERC20 ) public tokens; //address  of diff token is point to smart contract of token 
    
    constructor (address[] memory _tokens ) {
    for (uint i = 0; i < _tokens.length; i++) {
        tokens[_tokens[i]] = IERC20 (_tokens[i]);  
        
        //same working as above
        //address tokenAddress = _tokens[i];
        //tokens[tokenAddress] = IERC20(tokenAddress);
    }}
    
    
    // toexecute fl => lend tokens  
    function executeFlashloan (  
    address callback,   //to whom send tokens
    uint amount,
    address _token,
    bytes memory data  //arbitary data tobe forward to borrower
    )
    nonReentrant()
    external {
        IERC20 token = tokens[_token];  // poniter to token to be sent
        uint originalBalance = token.balanceOf(address(this)); //to store balance of token before lending
        require(address(token) != address(0) , "token not supported !"); //verify , we have lending token 
        require(originalBalance >= amount , "amount too high !");
        token.transfer(callback, amount);
        IFlashloanUser( callback) .flashloanCallback(amount , _token , data);
        require(token.balanceOf(address(this)) == originalBalance , "flashloan not reimburse ");
    }   
}