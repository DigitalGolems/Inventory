// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "../Store/Store.sol";
import "../Game.sol";
import "../../Utils/Owner.sol";

contract Modifiers is Owner {

    Game public game;
    Store public store;

    //setting address to contracts
    function setStoreContract(address _store) public isOwner {
        store = Store(_store);
    }

    function setGameContract(address _game) public isOwner {
        game = Game(payable(_game));
    }

    modifier onlyStore() {
        require(address(store) != address(0));
        require(address(store) == msg.sender, "Only Store");
        _;
    }

    modifier onlyGame() {
        require(address(game) != address(0));
        require(address(game) == msg.sender, "Only Game");
        _;
    }
    
}