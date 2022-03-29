// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "../../Utils/SafeMath.sol";
import "./Modifiers.sol";

contract Augmentations is Modifiers {

    using SafeMath32 for uint32;

    event ChangeAugmentationsAmount(uint8 newAmount);
    event ChangeAugmentations(address whose, uint32[] newAugmentations);
    event BuyAugmentation(address whose, uint16 ID, uint32 newAmount);
        
    // telekinetics;           //id 0
    // ichthyoTransformation;  //id 1
    // ornioTransformation;    //id 2
    // hacker;                 //id 3
    // shair;                  //id 4
    // impulse;                //id 5
    // meteodron;              //id 6
    // vibroImpact;            //id 7
    // holdIncrease;           //id 8
    uint8 public amountOfAugmentations = 9;
    mapping (address => mapping(uint16 => uint32)) public augmentations;


    //FOR DUEL
    function addAugmentations( 
        uint32[] memory _augmentationsAmount,
        address user
    ) public onlyGame {
        //each [i] is amount of one type
        require(_augmentationsAmount.length == amountOfAugmentations, "Not that amount");
        for (uint16 i = 0; i < amountOfAugmentations; i++){
            augmentations[user][i] = _augmentationsAmount[i];
        }
        emit ChangeAugmentations(user, _augmentationsAmount);
    }

    //FOR GAME
    function changeAmountOfOneAugmentation(
        uint16 ID,
        uint16 amount,
        address user
    ) public onlyGame {
        augmentations[user][ID] = amount;
        emit BuyAugmentation(user, ID, amount);
    }

    //FOR STORE
    function addAmountOfOneAugmentation(
        uint16 _ID, 
        uint16 _amount, 
        address _buyer
    ) public onlyStore {
        augmentations[_buyer][_ID] = augmentations[_buyer][_ID].add(_amount);
        emit BuyAugmentation(_buyer, _ID, _amount);
    }

    function getAugmentations(
        address user
    ) 
        public
        view 
        returns (uint32[] memory) 
    {
        uint32[] memory _augmentations = new uint32[](amountOfAugmentations);
        for (uint16 i = 0; i < amountOfAugmentations; i++){
            _augmentations[i] = augmentations[user][i];
        }
        return _augmentations;
    }

    function changeAugmentationsAmount(uint8 newAmount) public isOwner {
        amountOfAugmentations = newAmount;
        emit ChangeAugmentationsAmount(newAmount);
    }

    function getAugmentationsAmount() public view returns (uint8) {
        return amountOfAugmentations;
    }

}