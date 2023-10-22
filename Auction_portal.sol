pragma solidity ^0.8.0;

contract Auction {
    
    struct Item {
        string name;
        string description;
        address payable highestBidder;
        uint highestBid;
    }
    
    struct Bidder{
        uint bidderID;
        string name;
        address payable bidmaker;
    }
    mapping(uint => Item) public itemsList;
    mapping(uint => Bidder) public biddersList;
    uint public itemCount;
    uint public biddercount;
    
    constructor() {
        itemCount = 0;
        biddercount=0;
    }
  

    function createItem(string memory _name, string memory _description) public {
        itemCount++;
        itemsList[itemCount] = Item(_name, _description, payable(msg.sender), 0);
    }

    function bidderRegister(string memory _name) public payable{
        biddercount++;
        biddersList[biddercount]=Bidder(biddercount,_name,payable(msg.sender));
    }
    
    function placeBid(uint _itemId, uint _bidAmount,uint _bidderID) public payable {
        require(msg.sender==biddersList[_bidderID].bidmaker,"You are a fake bidder");
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID");
        require(_bidAmount > itemsList[_itemId].highestBid, "Bid amount must be higher than current highest bid");
        
        
        if (itemsList[_itemId].highestBidder != address(0)) {
            // Refund the previous highest bidder if exists
            itemsList[_itemId].highestBidder.transfer(itemsList[_itemId].highestBid);
        }
        
        itemsList[_itemId].highestBidder = payable(msg.sender);
        itemsList[_itemId].highestBid = _bidAmount;
    }
    
    function getWinningBid(uint _itemId) public view returns (address, uint) {
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID");
        
        return (itemsList[_itemId].highestBidder, itemsList[_itemId].highestBid);
    }
}
