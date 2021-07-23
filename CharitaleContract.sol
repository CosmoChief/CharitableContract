//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KarmaGateway
{
    
    /**
     * Contract owner
    **/
    address payable owner;
    
    /**
     * Charity address
    **/
    address public charityAddress = 0x798BC384E20d5D16987A07487FC695985F1742c5;
    
    event Payment(address indexed sender, address indexed to, uint256 amount, uint256 fee);
    event withdraw(address indexed _too, uint256 amount, uint256 timestamp);
    
    constructor () {
        owner = payable(address(msg.sender));
    }
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can execute this function");
        _;
    }

    function setCharityAddresss(address payable _address) public onlyOwner
    {
        charityAddress = _address;
    }
    
    function pay(address payable _to, uint256 _fee) external payable {
        require(msg.value > 0, "Must send BNB");
        require(msg.value >= 0.1 ether, "The minimal transfer is 0.1 BNB");
        require(_fee >= 2, "The minimal fee is 2%");
        require(_fee <= 75, "The maximum fee is 75%");
        
        uint256 amountFee = (msg.value / 100) * _fee;
        uint256 amountAfterFee = msg.value - amountFee;
        
        _to.transfer(amountAfterFee);
                
        emit Payment(msg.sender, _to, msg.value, amountFee);
    }
    
    function claimCharityDonationsToAddress(address payable _to, uint256 _amount) public onlyOwner {
        require(_amount <= address(this).balance, "Not enough balance");
        _to.transfer(_amount);
        emit withdraw(_to, _amount, block.timestamp);
  	}
  	
  	function claimCharityDonations() public onlyOwner {
  	    require(address(this).balance > 0, "Not enough balance");
        owner.transfer(address(this).balance);
        emit withdraw(owner, address(this).balance, block.timestamp);
  	}
  	
  	function claimCharityDonationsAmount(uint256 _amount) public onlyOwner {
  	    require(_amount <= address(this).balance, "Not enough balance");
        owner.transfer(_amount);
        emit withdraw(owner, _amount, block.timestamp);
  	}
  	
  	function getCharityBalance() public view returns (uint256) {
            return address(this).balance;
  	}
}   
