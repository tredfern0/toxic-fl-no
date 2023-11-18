// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.8;

//import "../libraries/Suave.sol";
import "../libraries/Suave.sol";

library UniV4Hook {
    // address of hook on mainnet/goerli
    // Contract that should return correct response - on Goerli!
    address constant hookAddr = 0x71c523718328D90318499950Fc2efD0E81Dd0545;
    string constant isSolverSig = "isSolver((address))";

    function getSwapperFee(
        address swapperAddr
    ) internal view returns (uint256 fee) {
        bytes memory output = Suave.ethcall(
            hookAddr,
            abi.encodeWithSignature(isSolverSig, swapperAddr)
        );
        bool isSolver = abi.decode(output, (bool));
        // 1% is default
        fee = 10000;
        if (isSolver) {
            // Reduce to .3% if they're a solver
            fee = 3000;
        }
        return fee;
    }
}

contract SwapperFeeCalc {
    event SwapperFee(address swapperAddr, uint64 swapperFee);

    function emitSwapperFee(
        address swapperAddr,
        uint64 swapperFee
    ) external payable {
        emit SwapperFee(swapperAddr, swapperFee);
    }

    /// @notice - user fee will be made up of an onchain score and an offchain score
    function calcUserFee(
        address swapperAddr
    ) external payable returns (bytes memory) {
        // require(Suave.isConfidential(), "Should be in execution env!");
        uint64 swapperScoreApi = precompileApiCall(swapperAddr);
        uint64 swapperScoreOnChain = precompileUniCall(swapperAddr);

        uint64 swapperFee = 10000 - (swapperScoreApi + swapperScoreOnChain);

        return
            abi.encodeWithSelector(
                this.emitSwapperFee.selector,
                swapperAddr,
                swapperFee
            );
    }

    /// @notice - in future can make an api call that calculates offchain data
    function precompileApiCall(
        address swapperAddr
    ) internal returns (uint64 swapperScoreApi) {
        // Call our initial precompile...
        swapperScoreApi = Suave.getUserDataFromApi(swapperAddr);
    }

    /// @notice - will make an onchain call to analyze axiom proofs committed to hook
    function precompileUniCall(
        address swapperAddr
    ) internal returns (uint64 swapperScoreOnChain) {
        // TODO - debug this call - do we need a precompile instead?
        // uint256 fee = UniV4Hook.getSwapperFee(swapperAddr);
        return 42;
    }
}
