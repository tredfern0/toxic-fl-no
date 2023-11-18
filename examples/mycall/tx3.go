package main

import (
	"fmt"
	"github.com/flashbots/suapp-examples/framework"
	"github.com/ethereum/go-ethereum/common"
)

// Our four calls:
// precompileApiCall
// publicFunc()
// privateStoreBid()
// precompileApiCall(address swapperAddr)
// precompileUniCall(address swapperAddr)

func main() {
	fr := framework.New()

    // example of a send with a public param - hintEvent.BidId
	//receipt = contractAddr2.SendTransaction("newMatch", []interface{}{hintEvent.BidId}, backRunBundleBytes)


	//fr.DeployContract("TestCalls.sol/OnlyConfidential.json").SendTransaction("helloWorld2", []interface{}{}, nil)
	//fr.DeployContract("TestCalls.sol/MyTestCalls.json").SendTransaction("precompileApiCall", []interface{}{"0x4611F6d137d1baf545378dD02C1b16eb63cbE755"}, nil)
    //let addr := common.HexToAddress("4611F6d137d1baf545378dD02C1b16eb63cbE755")

	addr := common.HexToAddress("4611F6d137d1baf545378dD02C1b16eb63cbE755")

	//fr.DeployContract("TestCalls.sol/MyTestCalls.json").SendTransaction("precompileApiCall", []interface{}{addr}, nil)
	contract := fr.DeployContract("TestCalls.sol/MyTestCalls.json")
    receipt := contract.SendTransaction("precompileApiCall", []interface{}{addr}, nil)

    fmt.Println(receipt.Logs[0])
	//hintEvent := &HintEvent{}
	//if err := hintEvent.Unpack(receipt.Logs[0]); err != nil {
	//	panic(err)
	//}

	//fmt.Println("Hint event id", hintEvent.BidId)

}
