// Code to confirm a given contract address is a cowswap solver
// Can be run by pasting code into axiom repl at:
// https://repl.axiom.xyz/
//
//https://etherscan.io/address/0x9008d19f58aabd9ed0d60971565aa8510560ab41
//


const cowswapAddr = "0x9008d19f58aabd9ed0d60971565aa8510560ab41";
// keccak of this event: Settlement (index_topic_1 address solver)
const eventSchema = "0x40338ce1a7c49204f0099533b1e9a7ee0a3d261f84974ab7af36105b8c4e9db4";
let receipt = getReceipt(txBlockNumber, txIdx);
// access the address that emitted the log event at index 0
let logAddr = receipt.log(0).address();

// Need to confirm the cowswap contract was the one that emitted this...
checkEqual(constant(cowswapAddr), logAddr.toCircuitValue());

// access the topic at index 1 of the log event at index 0 and check it has schema eventSchema
// because `address` is indexed in the event, this corresponds to `address`
let solverAddress = receipt.log(logIdx).topic(0, eventSchema); 

addToCallback(solverAddress);


// https://goerli.etherscan.io/tx/0xce3148dc2cd5188fdf1d7d72ab4d4b0ee994a58262b630e3e788fd5ac7c1e2f4#eventlog
// Expected output address: 0xb98e94C06660A639A951B64FE9EF295fc2fABE1d
// get 'txIdx' from Position In Block in "Other Attributes" section
{
    "txBlockNumber": 10068708,
        "txIdx": 9,
            "logIdx": 27
}



// https://goerli.etherscan.io/tx/0x05862017b7419820ed37bce77cdfeaafad6a0e81bca5e602d1a89b0d162e8333
// Expected output address: 0x0f159eCb06134BA5fd2914B059b57C1dB67b983a
{
    "txBlockNumber": 10068084,
        "txIdx": 22,
            "logIdx": 29
}

// Alternate one...
