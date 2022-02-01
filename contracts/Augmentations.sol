// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "../../Utils/SafeMath.sol";
import "../Store/Store.sol";
import "../Game.sol";

contract Augmentations {

    using SafeMath for uint;
    using SafeMath32 for uint32;

    Game public game;
    Store public store;

    event ChangeAugmentations(address whose, uint32[] newAugmentations);
    event ChangeOneAugmentation(address whose, uint16 ID, uint32 newAmount);
        
    struct Augmentation {
        uint16 ID;
        uint32 amount;
    }
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
    mapping (address => mapping(uint16 => Augmentation)) public augmentations;


    //FOR DUEL AND STORE
    function addAugmentations( 
        uint32[] memory _augmentationsAmount,
        address user
    ) public onlyGameOrStore {
        //each [i] is amount of one type
        require(_augmentationsAmount.length == amountOfAugmentations, "Not that amount");
        for (uint16 i = 0; i < amountOfAugmentations; i++){
            augmentations[user][i] = Augmentation(
                i,
                _augmentationsAmount[i]
            );
        }
        emit ChangeAugmentations(user, _augmentationsAmount);
    }

    //FOR STORE
    function addAmountOfOneAugmentation(uint16 _ID, uint16 _amount, address _buyer) public onlyGameOrStore {
        augmentations[_buyer][_ID].amount = augmentations[_buyer][_ID].amount.add(_amount);
        emit ChangeOneAugmentation(_buyer, _ID, _amount);
    }

    function getAugmentations(address user) public view returns (uint32[] memory) {
        uint32[] memory _augmentations = new uint32[](amountOfAugmentations);
        for (uint16 i = 0; i < amountOfAugmentations; i++){
            _augmentations[i] = augmentations[user][i].amount;
        }
        return _augmentations;
    }

    modifier onlyGameOrStore() {
        // require((address(game) != address(0)) && (address(store) != address(0)), "Game or Store Not Set");
        require((address(game) == msg.sender) || (address(store) == msg.sender), "Only Game Or Store");
        _;
    }
}