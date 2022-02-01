// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "../../Utils/SafeMath.sol";
import "./Augmentations.sol";

contract Resources is Augmentations {
    
    using SafeMath for uint;
    using SafeMath32 for uint32;


    event ChangeResources(address whose, uint32[] newResources);
    event ChangeOneResource(address whose, uint16 ID, uint32 newAmount);

    struct Resource {
        uint16 ID;
        uint32 amount;
    }
    //lymph;    //id 0
    //ash;      //id 1
    //flowerum; //id 2
    //electron; //id 3

    uint8 public amountOfResources = 4;
    mapping (address =>mapping(uint16 => Resource)) resources;

        //FOR DUEL AND STORE
    function addResources( 
        uint32[] memory _resourcesAmount,
        address user
    ) public onlyGameOrStore {
        //each [i] is amount of one type
        require(_resourcesAmount.length == amountOfResources, "Not that amount");
        for (uint16 i = 0; i < amountOfResources; i++){
            resources[user][i] = Resource(
                i,
                _resourcesAmount[i]
            );
        }
        emit ChangeResources(user, _resourcesAmount);
    }

    //FOR STORE
    function addAmountOfOneResource(uint16 _ID, uint16 _amount, address _buyer) public onlyGameOrStore {
        resources[_buyer][_ID].amount = resources[_buyer][_ID].amount.add(_amount);
        emit ChangeOneResource(_buyer, _ID, _amount);
    }

    function getResources(address user) public view returns (uint32[] memory) {
        uint32[] memory _resources = new uint32[](amountOfResources);
        for (uint16 i = 0; i < amountOfResources; i++){
            _resources[i] = resources[user][i].amount;
        }
        return _resources;
    }

}