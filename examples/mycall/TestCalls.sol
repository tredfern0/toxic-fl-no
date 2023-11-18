// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.8;

//import "../libraries/Suave.sol";
import "../../suave-geth/suave/sol/libraries/Suave.sol";



library UniV4Hook {
    // address of hook on mainnet/goerli
    // Contract that should return correct response - on Goerli!
    address constant hookAddr = 0x71c523718328D90318499950Fc2efD0E81Dd0545;
    string constant isSolverSig = "isSolver((address))";

    function getSwapperFee(address swapperAddr) internal view returns (uint256 fee) {
        bytes memory output = Suave.ethcall(hookAddr, abi.encodeWithSignature(isSolverSig, swapperAddr));
        (bool isSolver) = abi.decode(output, (bool));
        // 1% is default
        fee = 10000;
        if (isSolver) {
            // Reduce to .3% if they're a solver
            fee = 3000;
        }
        return fee;
    }
}



contract MyTestCalls {
	event CB0();
	event CB1();
	event CB2(uint64 swapperScore);
	event CB3(uint256 fee);

    function callback1() external payable {
        // Nothing?
        emit CB1();
    }

    function callback2(uint64 swapperScore) external payable {
        // Nothing?
        emit CB2(swapperScore);
    }

    function callback3(uint256 fee) external payable {
        // Nothing?
        emit CB3(fee);
    }

    // Public function - should not need callback?
	function publicFunc() external payable returns (uint8) {
        require(!Suave.isConfidential(), "Should not be in execution env!");
        // emit CB0();
        return 3;
    }


    // copied from ConfidentialStore example...
    function privateStoreBid() external payable returns (bytes memory) {

        address[] memory allowedList = new address[](1);
        allowedList[0] = address(this);

        Suave.Bid memory bid = Suave.newBid(
            10,
            allowedList,
            allowedList,
            "namespace"
        );

        Suave.confidentialStore(bid.id, "key1", abi.encode(1));

        bytes memory value = Suave.confidentialRetrieve(bid.id, "key1");
        require(keccak256(value) == keccak256(abi.encode(1)));

        // QUESTION - so this is just an example of how to access data... we could do it in another function?
        Suave.Bid[] memory allShareMatchBids = Suave.fetchBids(10, "namespace");
        return abi.encodeWithSelector(this.callback1.selector);

    }


	function precompileApiCall(address swapperAddr) external returns (bytes memory) {
        // or should we pull address here from private datastore?
        //addr = ...

        require(Suave.isConfidential(), "Should not be in execution env!");

        // Call our initial precompile...
        uint64 swapperScore = Suave.getUserDataFromApi(swapperAddr);
        //uint64 swapperScore = 12;

        //return bytes.concat(this.emitCallback.selector, abi.encode(1));
        return abi.encodeWithSelector(this.callback2.selector, swapperScore);
        //return abi.encodeWithSelector(this.callback2.selector, swapperScore);
    }

    function precompileUniCall(address swapperAddr) external payable returns (bytes memory) {
        uint256 fee = UniV4Hook.getSwapperFee(swapperAddr);
        //return abi.encodeWithSelector(this.callback3.selector, fee);
        return bytes.concat(abi.encodeWithSelector(this.callback3.selector, abi.encode(fee)));
    }


}
