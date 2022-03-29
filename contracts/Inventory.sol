// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "./Things.sol";

contract Inventory is Things {

    using SafeMath for uint;
    using SafeMath32 for uint32;

    //losing inventory after duel
    function loseFromInventory(
        address _winner,
        address _loser,
        uint32 _cardWinCount,
        uint32 _cardLoseCount,
        uint32 _winnerWinCount,
        uint32 _loserLoseCount
    )
    public onlyGame
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
                                _loserLoseCount,
                                block.timestamp
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
                                    typeOfInventory,
                                    block.timestamp
                                )
                                )
                            )

                ) % amountOfThings;
            uint32 thingsAmountLoser = things[_loser][typeOfThings];
            //deleting from loser
            //adding to winner
            if (thingsAmountLoser != 0) {
                things[_loser][typeOfThings] = things[_loser][typeOfThings].sub(1);
                things[_winner][typeOfThings] = things[_winner][typeOfThings].add(1);
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
                                    typeOfInventory,
                                    block.timestamp
                                )
                            )
                    )
                ) % amountOfResources;
            uint32 resourcesAmountLoser = resources[_loser][typeOfResources];
            //deleting from loser
            //adding to winner
            if (resourcesAmountLoser != 0) {
                resources[_loser][typeOfResources] = resources[_loser][typeOfResources].sub(1);
                resources[_winner][typeOfResources] = resources[_winner][typeOfResources].add(1);
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
                                    typeOfInventory,
                                    block.timestamp
                                )
                            )
                    )
                ) % amountOfAugmentations;
            uint32 augmentationsAmountLoser = augmentations[_loser][typeOfAugmentations];
            //deleting from loser
            //adding to winner
            if (augmentationsAmountLoser != 0) {
                augmentations[_loser][typeOfAugmentations] = augmentations[_loser][typeOfAugmentations].sub(1);
                augmentations[_winner][typeOfAugmentations] = augmentations[_winner][typeOfAugmentations].add(1);
            }
        }
    }
}
