// Code to confirm a given contract address is a cowswap solver
// Can be run by pasting code into axiom repl at:
// https://repl.axiom.xyz/

const cowswapAddr = "0x9008d19f58aabd9ed0d60971565aa8510560ab41";
const eventSchema = "0x40338ce1a7c49204f0099533b1e9a7ee0a3d261f84974ab7af36105b8c4e9db4";
let receipt = getReceipt(txBlockNumber, txIdx);
// access the address that emitted the log event at index 0
let logAddr = receipt.log(0).address();

// Need to confirm the cowswap contract was the one that emitted this...
checkEqual(constant(cowswapAddr), logAddr.toCircuitValue());

// access the topic at index 1 of the log event at index 0 and check it has schema eventSchema
// because `address` is indexed in the event, this corresponds to `address`
let solverAddress = receipt.log(0).topic(0, eventSchema); 

addToCallback(solverAddress);

