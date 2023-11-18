package main

import (
	"fmt"
	"github.com/ethereum/go-ethereum/common"
	"github.com/flashbots/suapp-examples/framework"
)

// Our four calls:
// precompileApiCall
// publicFunc()
// privateStoreBid()
// precompileApiCall(address swapperAddr)
// precompileUniCall(address swapperAddr)

//var (
//	// This is the address we used when starting the MEVM
//	//exNodeEthAddr = common.HexToAddress("b5feafbdd752ad52afb7e1bd2e40432a485bbb7f")
//    addr = common.HexToAddress("4611F6d137d1baf545378dD02C1b16eb63cbE755")
//)

func main() {
	fr := framework.New()
	//fr.DeployContract("TestCalls.sol/OnlyConfidential.json").SendTransaction("helloWorld2", []interface{}{}, nil)
	//fr.DeployContract("TestCalls.sol/MyTestCalls.json").SendTransaction("helloWorld", []interface{}{}, nil)

	//fr.DeployContract("TestCalls.sol/MyTestCalls.json").SendTransaction("precompileApiCall", []interface{}{"0x4611F6d137d1baf545378dD02C1b16eb63cbE755"}, nil)
	addr := common.HexToAddress("4611F6d137d1baf545378dD02C1b16eb63cbE755")
	//fr.DeployContract("TestCalls.sol/MyTestCalls.json").SendTransaction("precompileApiCall", []interface{}{addr}, nil)

	contract := fr.DeployContract("TestCalls.sol/MyTestCalls.json")
    receipt := contract.SendTransaction("precompileUniCall", []interface{}{addr}, nil)

    fmt.Println(receipt.Logs[0])

	// example of a send with a public param - hintEvent.BidId
	//receipt = contractAddr2.SendTransaction("newMatch", []interface{}{hintEvent.BidId}, backRunBundleBytes)

}
