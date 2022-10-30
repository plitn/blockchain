pragma solidity >=0.8.4 <0.9.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DmitrinPA is ERC20 {

    uint256 constant initialSupply = 1000000 * (10**18);
    
    constructor() ERC20("DmitrinPA", "KOD") {
         _mint(msg.sender, initialSupply);
    }
}