// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "./Resources.sol";

contract Things is Resources {

    using SafeMath32 for uint32;

    event ChangeThingsAmount(uint8 newAmount);
    event ChangeThings(address whose, uint32[] newThings);
    event BuyThing(address whose, uint16 ID, uint32 newAmount);

    // note;    //id 0
    // booster; //id 1
    // snare;   //id 2
    // trap;    //id 3
    // bait;    //id 4

    uint8 public amountOfThings = 5;
    mapping (address => mapping(uint16 => uint32)) things;

    //FOR DUEL AND STORE
    function addThings( 
        uint32[] memory _thingsAmount,
        address user
    ) public onlyGame {
        //each [i] is amount of one type
        require(_thingsAmount.length == amountOfThings, "Not that amount");
        for (uint16 i = 0; i < amountOfThings; i++){
            things[user][i] = _thingsAmount[i];
        }
        emit ChangeThings(user, _thingsAmount);
    }

    //FOR GAME
    function changeAmountOfOneThing(
        uint16 ID, 
        uint16 amount, 
        address user
    ) public onlyGame {
        things[user][ID] = amount;
        emit BuyResource(user, ID, amount);
    }

    //FOR STORE
    function addAmountOfOneThing(
        uint16 _ID, 
        uint16 _amount, 
        address _buyer
    ) public onlyStore {
        things[_buyer][_ID] = things[_buyer][_ID].add(_amount);
        emit BuyThing(_buyer, _ID, _amount);
    }

    function getThings(
        address user
    ) 
        public 
        view 
        returns 
        (uint32[] memory) 
    {
        uint32[] memory _things = new uint32[](amountOfThings);
        for (uint16 i = 0; i < amountOfThings; i++){
            _things[i] = things[user][i];
        }
        return _things;
    }

    function changeThingsAmount(uint8 newAmount) public isOwner {
        amountOfThings = newAmount;
        emit ChangeThingsAmount(newAmount);
    }
    
    function getThingsAmount() public view returns (uint8) {
        return amountOfThings;
    }


}