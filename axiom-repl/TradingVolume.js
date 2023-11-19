
// So confirm every transaction in array was initiated by user, sum them up and return the sum


const eventSchema = "0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822";

let swapSum = constant(0);

for (let i = 0; i < 2; i++) {
    let dat = txList[i];
    let receipt = getReceipt(dat["txBlockNumber"], dat["txIdx"]);
    // access the address that emitted the log event at index 0
    let logAddr = receipt.log(0).address();

    // Need to confirm the cowswap contract was the one that emitted this...
    //checkEqual(constant(cowswapAddr), logAddr.toCircuitValue());

    // access the topic at index 1 of the log event at index 0 and check it has schema eventSchema
    // because `address` is indexed in the event, this corresponds to `address`
    let swapAmount = receipt.log(0).topic(0, eventSchema);
    swapSum = add(swapSum, swapAmount.toCircuitValue());
}
addToCallback(swapSum);

// This user has a lot of transactions...
// https://goerli.etherscan.io/address/0x5fb9fe2823c908031739f9d8fbc28a70beb3adb7

// First two txs:
//https://goerli.etherscan.io/tx/0x8b9748ec1f63cc06a99a8ae5e7876f94261d97e57f1984ba16f451147c63edfa#eventlog
//https://goerli.etherscan.io/tx/0xa35b980866e2bf5aa136664331a5f136a092a819e9f45acb11910e59c309f37c

/*
{
    "txList": [{
        "txBlockNumber": 10068704,
        "txIdx": 33,
        "logIdx": 78
    },
    {
        "txBlockNumber": 10068779,
        "txIdx": 14,
        "logIdx": 36
    }
    ]
};
*/



// https://goerli.etherscan.io/tx/0xe35757fb47363792fba21122aba6ee4cdab9cdd4ddf352b4361f0be0951e3e95
// https://goerli.etherscan.io/tx/0x4eae7da7aa1f04e72d21cc08b19c9734052e7510c471278a8bc50623f7beb713

/*
{
    "txList": [{
        "txBlockNumber": 10068323,
        "txIdx": 11,
        "logIdx": 20
    },
    {
        "txBlockNumber": 10068334,
        "txIdx": 13,
        "logIdx": 14
    },
    ]
}
*/
