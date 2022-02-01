// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "../Store/Store.sol";
import "../Game.sol";
import "./Things.sol";
import "../../Utils/Owner.sol";

contract Inventory is Things, Owner {

    using SafeMath for uint;
    using SafeMath32 for uint32;

    event ChangeThingsAmount(uint8 newAmount);
    event ChangeResourcesAmount(uint8 newAmount);
    event ChangeAugmentationsAmount(uint8 newAmount);

    //setting address to contracts
    function setStoreContract(address _store) public isOwner {
        store = Store(_store);
    }

    function setGameContract(address _game) public isOwner {
        game = Game(payable(_game));
    }

    //change amounts of things/resources/augment isOwner
    //get amount of type of things/resources/augment
    function changeThingsAmount(uint8 newAmount) public isOwner {
        amountOfThings = newAmount;
        emit ChangeThingsAmount(newAmount);
    }
    
    function getThingsAmount() public view returns (uint8) {
        return amountOfThings;
    }

    function changeResourcesAmount(uint8 newAmount) public isOwner {
        amountOfResources = newAmount;
        emit ChangeResourcesAmount(newAmount);
    }

    function getResourcesAmount() public view returns (uint8) {
        return amountOfResources;
    }

    function changeAugmentationsAmount(uint8 newAmount) public isOwner {
        amountOfAugmentations = newAmount;
        emit ChangeAugmentationsAmount(newAmount);
    }

    function getAugmentationsAmount() public view returns (uint8) {
        return amountOfAugmentations;
    }

    //losing inventory after duel
    function loseFromInventory(
        address _winner, 
        address _loser,
        uint32 _cardWinCount,
        uint32 _cardLoseCount,
        uint32 _winnerWinCount,
        uint32 _loserLoseCount
    ) 
    public onlyGameOrStore 
    {
        //"random" number of inventory
        //0 - things
        //1 - resources
        //2 - augment
        uint16 typeOfInventory = 
            uint16(
                uint256(
                        keccak256(
                            abi.encodePacked(
                                _winner, 
                                _loser,
                                _cardWinCount,
                                _cardLoseCount,
                                _winnerWinCount,
                                _loserLoseCount
                            )
                        )
                )
            ) % 3;
        if (typeOfInventory == 0) {
            //things
            //random id of things
            uint16 typeOfThings = 
                uint16(
                    uint256(
                            keccak256(
                                abi.encodePacked(
                                    _winner, 
                                    _loser,
                                    _cardWinCount,
                                    _cardLoseCount,
                                    _winnerWinCount,
                                    _loserLoseCount,
                                    typeOfInventory
                                )
                                )
                            )
                    
                ) % amountOfThings;
            uint32 thingsAmountLoser = things[_loser][typeOfThings].amount;
            //deleting from loser
            //adding to winner
            if (thingsAmountLoser != 0) {
                things[_loser][typeOfThings].amount = things[_loser][typeOfThings].amount.sub(1);
                things[_winner][typeOfThings].amount = things[_winner][typeOfThings].amount.add(1);
            }
        }
        if (typeOfInventory == 1){
            //resources
            //random id of resources
            uint16 typeOfResources = 
                uint16(
                    uint256(
                            keccak256(
                                abi.encodePacked(
                                     _winner, 
                                    _loser,
                                    _cardWinCount,
                                    _cardLoseCount,
                                    _winnerWinCount,
                                    _loserLoseCount,
                                    typeOfInventory
                                )
                            )
                    )
                ) % amountOfResources;
            uint32 resourcesAmountLoser = resources[_loser][typeOfResources].amount;
            //deleting from loser
            //adding to winner
            if (resourcesAmountLoser != 0) {
                resources[_loser][typeOfResources].amount = resources[_loser][typeOfResources].amount.sub(1);
                resources[_winner][typeOfResources].amount = resources[_winner][typeOfResources].amount.add(1);
            }
        }
        if (typeOfInventory == 2) {
            //augmentations
            //random id of augmentations
            uint16 typeOfAugmentations = 
                uint16(
                    uint256(
                            keccak256(
                                abi.encodePacked(
                                     _winner, 
                                    _loser,
                                    _cardWinCount,
                                    _cardLoseCount,
                                    _winnerWinCount,
                                    _loserLoseCount,
                                    typeOfInventory
                                )
                            )
                    )
                ) % amountOfAugmentations;
            uint32 augmentationsAmountLoser = augmentations[_loser][typeOfAugmentations].amount;
            //deleting from loser
            //adding to winner
            if (augmentationsAmountLoser != 0) {
                augmentations[_loser][typeOfAugmentations].amount = augmentations[_loser][typeOfAugmentations].amount.sub(1);
                augmentations[_winner][typeOfAugmentations].amount = augmentations[_winner][typeOfAugmentations].amount.add(1);
            }
        }
    }
}