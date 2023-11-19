// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.8;

import "../libraries/Suave.sol";

contract TopOfBlockAuction {
    event AuctionWinner(address searcherAddr, uint64 swapperFee);

    function emitAuctionWinner(
        address swapperAddr,
        uint64 swapperFee
    ) external payable {
        emit AuctionWinner(swapperAddr, swapperFee);
    }

    function nullCallback() external payable {
        // Private auction?  Don't even emit event showing that someone bid
    }

    // slightly modified from ConfidentialStore example...
    function privateStoreBid(uint64 feeBid) public payable returns (bytes memory) {
        // User will need to pass in the max fee they're willing to bid here...
        // bytes memory feeBid = Suave.confidentialInputs();
        // Don't need to cast here because we have to store it in bytes anyways
        // uint64 feeBidInt = abi.decode(feeBid);

        address[] memory allowedList = new address[](1);
        allowedList[0] = address(this);

        Suave.Bid memory bid = Suave.newBid(
            10,
            allowedList,
            allowedList,
            "topOfBlockAuction"
        );

        //Suave.confidentialStore(bid.id, "key1", abi.encode(1));
        // function confidentialStore(BidId bidId, string memory key, bytes memory data1) internal view
        Suave.confidentialStore(bid.id, "key1", abi.encode(feeBid));

        //Unnecessary?
        //bytes memory value = Suave.confidentialRetrieve(bid.id, "key1");
        //require(keccak256(value) == keccak256(abi.encode(1)));

        // Because it's an internal auction don't think we need to emit any events
        return abi.encodeWithSelector(this.nullCallback.selector);
    }

    function settleAuction() public payable returns (bytes memory) {
        // Very basic logic - iterate over list of bids and see what is highest one
        uint64 winningFee = 0;
        address auctionWinner = address(0);
        Suave.Bid memory bid;
        Suave.Bid[] memory allShareMatchBids = Suave.fetchBids(
            10,
            "topOfBlockAuction"
        );

        for (uint i = 0; i < allShareMatchBids.length; i++) {
            bid = allShareMatchBids[i];
            //Suave.BidId b = bid.id;
            bytes memory feeBid = Suave.confidentialRetrieve(bid.id, "key1");
            //    //bytes memory feeBid2 = Suave.confidentialRetrieve(bid.id, "key1");
            //    // TODO - we need to be passing in the address here too, so we can gate reduced fees to a specific address
            uint64 feeBidInt = abi.decode(feeBid, (uint64));

            if (feeBidInt > winningFee) {
                winningFee = feeBidInt;
                // auctionWinner = ...
            }
        }

        return
            abi.encodeWithSelector(
                this.emitAuctionWinner.selector,
                auctionWinner,
                winningFee
            );
    }
}
