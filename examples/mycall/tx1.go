package main

import (
	"github.com/flashbots/suapp-examples/framework"
)

// Our four calls:
// precompileApiCall
// publicFunc()
// privateStoreBid()
// precompileApiCall(address swapperAddr)
// precompileUniCall(address swapperAddr)

func main() {
	fr := framework.New()
	fr.DeployContract("TestCalls.sol/MyTestCalls.json").SendTransaction("publicFunc", []interface{}{}, nil)
}
