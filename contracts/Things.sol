// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "../../Utils/SafeMath.sol";
import "./Resources.sol";

contract Things is Resources {

    using SafeMath for uint;
    using SafeMath32 for uint32;

    event ChangeThings(address whose, uint32[] newThings);
    event ChangeOneThing(address whose, uint16 ID, uint32 newAmount);

    struct Thing {
        uint16 ID;
        uint32 amount;
    }
    // note;    //id 0
    // booster; //id 1
    // snare;   //id 2
    // trap;    //id 3
    // bait;    //id 4

    uint8 public amountOfThings = 5;
    mapping (address => mapping(uint16 => Thing)) things;

    //FOR DUEL AND STORE
     function addThings( 
        uint32[] memory _thingsAmount,
        address user
    ) public onlyGameOrStore {
        //each [i] is amount of one type
        require(_thingsAmount.length == amountOfThings, "Not that amount");
        for (uint16 i = 0; i < amountOfThings; i++){
            things[user][i] = Thing(
                i,
                _thingsAmount[i]
            );
        }
        emit ChangeThings(user, _thingsAmount);
    }

    //FOR STORE
    function addAmountOfOneThing(uint16 _ID, uint16 _amount, address _buyer) public onlyGameOrStore {
        things[_buyer][_ID].amount = things[_buyer][_ID].amount.add(_amount);
        emit ChangeOneThing(_buyer, _ID, _amount);
    }

    function getThings(address user) public view returns (uint32[] memory) {
        uint32[] memory _things = new uint32[](amountOfThings);
        for (uint16 i = 0; i < amountOfThings; i++){
            _things[i] = things[user][i].amount;
        }
        return _things;
    }

}