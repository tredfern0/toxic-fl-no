package main

import (
	"github.com/flashbots/suapp-examples/framework"
	"encoding/json"
)

// Our four calls:
// precompileApiCall
// publicFunc()
// privateStoreBid()
// precompileApiCall(address swapperAddr)
// precompileUniCall(address swapperAddr)

func main() {
	fr := framework.New()
	pretendBid := 27;
	pretendBidBytes, _ := json.Marshal(pretendBid)
	fr.DeployContract("TestCalls.sol/MyTestCalls.json").SendTransaction("privateStoreBid", []interface{}{}, pretendBidBytes)

    // And now can we somehow access the bid?


}
