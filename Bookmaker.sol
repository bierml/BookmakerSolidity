// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Bookmaker
{
    modifier OnlyOwner {
        require(msg.sender == owner,"This function can be called only by owner!");
        _;
    }
    constructor() payable
    {
        owner = payable(msg.sender);
    }
    //structure for participant's data
    struct ParData {
        //better's address
        address payable paddr;
        //better's answer
        uint ansind;
        //bet sum
        uint summ;
    }
    //structure for bet's data
    struct Bet{
        //koefficients of different answers for this bet
        uint256[] koeff;
        //question for the bet
        string question;
        //answer variants array
        string[] answers;
        //array of participants data
        ParData[] participants;
    }
    //shortened structure for bet's data displaying
    struct rBet{
        //koefficients of different answers for this bet
        uint256[] koeff;
        //question for the bet
        string question;
        //answer variants array
        string[] answers;
    }
    //Bet[] betsarr;
    mapping(string => Bet) private betsarr;
    //bet's aliases
    //useful for enumeration of existing bets
    string[] private betsaliases;
    //owner of the contract
    address payable private owner;
    //storages margin multiplied by 10 000
    uint private margin = 0;
    function setmargin(uint margin_) public OnlyOwner
    {
        margin = margin_;
    }

    function addbet(string memory betname, string memory question,string[] memory answers,uint[] memory prob) public OnlyOwner
    {
        require(margin != 0,"Margin not set!");
        //Bet memory newbet;
        //newbet.question = question;
        //newbet.answers = answers;
        //newbet.participants = new ParData[](0);
        betsarr[betname].question = question;
        betsarr[betname].answers = answers;
        betsaliases.push(betname);
        for(uint i = 0;i<prob.length;i++)
        {
            //betsarr[betname].koeff.push();
            //betsarr[betname].koeff[i]=(((10000*10000)/(prob[i]+margin/prob.length)));
            betsarr[betname].koeff.push((((10000*10000)/(prob[i]+margin/prob.length))));
        }
    }
    function payinbet(string memory betname,uint ansind) public payable OnlyOwner {
        uint paymentsum = 0;
        for(uint i = 0;i<betsarr[betname].participants.length;i++)
        {
            if(ansind==betsarr[betname].participants[i].ansind)
            paymentsum += (betsarr[betname].participants[i].summ*betsarr[betname].koeff[ansind])/10000;
        }
        require(paymentsum<address(this).balance,"Not enough ethereum for payment!");
        for(uint i = 0;i<betsarr[betname].participants.length;i++)
        {
            if(ansind==betsarr[betname].participants[i].ansind)
            betsarr[betname].participants[i].paddr.transfer((betsarr[betname].participants[i].summ*betsarr[betname].koeff[ansind])/10000);
        }
    }
    function GetRemainder() public OnlyOwner 
    {
        owner.transfer(address(this).balance);
    }
    function AddMoney() public payable OnlyOwner
    {
        payable(address(this)).transfer(msg.value);
    }
    /*function participate(string memory betname,uint answer,uint summ) public payable
    {
        (bool sent, ) = owner.call{value: summ}("");
        require(sent, "Failed to send Ether");
        ParData memory data;
        data.paddr = payable(msg.sender);
        data.ansind = answer;
        data.summ = summ;
        betsarr[betname].participants.push(data);
    }
    function participate(string memory betname,uint answer) public payable
    {
        (bool sent, ) = owner.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
        ParData memory data;
        data.paddr = payable(msg.sender);
        data.ansind = answer;
        data.summ = address(this).balance;
        betsarr[betname].participants.push(data);
    }*/
    function participate(string memory betname,uint answer) public payable
    {
        //owner.transfer(summ);
        require(msg.value!=0,"Add ethereum to your transaction to bet!");
        payable(address(this)).transfer(msg.value);
        ParData memory data;
        data.paddr = payable(msg.sender);
        data.ansind = answer;
        data.summ = msg.value;
        betsarr[betname].participants.push(data);
    }
    function getbetdata(string memory betname) view  public returns(rBet memory)
    {
        rBet memory rdata;
        rdata.koeff = betsarr[betname].koeff;
        rdata.question = betsarr[betname].question;
        rdata.answers = betsarr[betname].answers;
        return rdata;
    }

    function getbetslist() view public returns(string[] memory)
    {
        return betsaliases;
    }
    receive() external payable {}
    //prob[i] storages Pi multiplied by 10 000
    //for example: Pi=0.4532 => prob[i]=4532
    /*function setdistribution(uint[] memory prob) public OnlyOwner
    {
        require(margin != 0,"Margin not set!");
        for(uint i = 0;i<prob.length;i++)
        {
            koeff.push(((10000*10000)/(prob[i]+margin/prob.length)));
        }
    }
    function getkoeff(uint i) view  public OnlyOwner returns(uint)
    {
        return koeff[i];
    }*/
}