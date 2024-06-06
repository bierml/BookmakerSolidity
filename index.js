import Web3 from 'web3';
import configuration from '../build/contracts/Bookmaker.json';
import 'bootstrap/dist/css/bootstrap.css';

const participate = document.getElementById('participate');
const getbetslist = document.getElementById('getbetslist');
const getbetdata = document.getElementById('getbetdata');
const setmargin = document.getElementById('setmargin');
const addbet = document.getElementById('addbet');
const addmoney = document.getElementById('addmoney');
const getremainder = document.getElementById('getremainder');
const payingbet = document.getElementById('paybet');
participate.addEventListener('click', function() {
  participateHelper();
});
getbetslist.addEventListener('click', function() {
  getbetlistHelper();
});
getbetdata.addEventListener('click', function() {
  getbetdataHelper();
});
setmargin.addEventListener('click', function() {
  setmarginHelper();
});
addbet.addEventListener('click', function() {
  addbetHelper();
});
addmoney.addEventListener('click', function() {
  addMoneyHelper();
});
getremainder.addEventListener('click', function() {
  getRemainderHelper();
});
payingbet.addEventListener('click', function() {
  payinbet();
});
const CONTRACT_ADDRESS =
  configuration.networks['5777'].address;
const CONTRACT_ABI = configuration.abi;

const web3 = new Web3(
  Web3.givenProvider || 'http://127.0.0.1:7545'
);
const contract = new web3.eth.Contract(
  CONTRACT_ABI,
  CONTRACT_ADDRESS
);

let account;

const accountEl = document.getElementById('account');

function participateHelper() {
    betalias = $("#betalias").val();
    answer = $("#youranswer").val();
    money = $("#money").val();
    const valueToSend = web3.utils.toWei(money, 'ether');
    contract.methods.participate(betalias,answer).send({from: account, value: valueToSend}).then();
    //console.log(info);
}
function getbetlistHelper() {
  contract.methods.getbetslist().call().then( function( info ) {
    console.log("info: ", info);
    document.getElementById('lastInfo').innerHTML = info;
  });
}
function getbetdataHelper() {
    betalias = $("#sbetalias").val();
    contract.methods.getbetdata(betalias).call().then(function(res) {document.getElementById('pbetdata').innerHTML = res;});
}
function addbetHelper() {
    betname = $("#betname").val();
    betquestion = $("#betquestion").val();
    answersarr = $("#answersarr").val().split(",");
    probsarr = $("#probsarr").val().split(",");
    console.log(answersarr);
    console.log(probsarr);
    contract.methods.addbet(betname,betquestion,answersarr,probsarr).send({from: account}).then();
}
function addMoneyHelper() {
    summ = $("#moneysumm").val();
    console.log(summ);
    const valueToSend = web3.utils.toWei(summ, 'ether');
    //console.log(summ);
    contract.methods.AddMoney().send({from: account, value: valueToSend}).then();
}
function getRemainderHelper() {
  contract.methods.GetRemainder().send({from: account}).then();
}
function payinbet() {
    betal = $("#betal").val();
    rans = $("#rans").val();
    contract.methods.payinbet(betal,rans).send({from: account}).then();
}
function setmarginHelper() {
    margin = $("#mymargin").val();
    console.log(margin);
    contract.methods.setmargin(margin).send({from: account}).then();
}

const main = async () => {
  const accounts = await web3.eth.requestAccounts();
  account = accounts[0];
  accountEl.innerText = account;
};
main();