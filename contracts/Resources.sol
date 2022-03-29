// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
pragma solidity 0.8.10;

import "./Augmentations.sol";

contract Resources is Augmentations {
    
    using SafeMath32 for uint32;

    event ChangeResourcesAmount(uint8 newAmount);
    event ChangeResources(address whose, uint32[] newResources);
    event BuyResource(address whose, uint16 ID, uint32 newAmount);

    //lymph;    //id 0
    //ash;      //id 1
    //flowerum; //id 2
    //electron; //id 3
    uint8 public amountOfResources = 4;
    mapping (address =>mapping(uint16 => uint32)) resources;

    //FOR DUEL AND STORE
    function addResources( 
        uint32[] memory _resourcesAmount,
        address user
    ) public onlyGame {
        //each [i] is amount of one type
        require(_resourcesAmount.length == amountOfResources, "Not that amount");
        for (uint16 i = 0; i < amountOfResources; i++){
            resources[user][i] = _resourcesAmount[i];
        }
        emit ChangeResources(user, _resourcesAmount);
    }

    //FOR GAME
    function changeAmountOfOneResource(
        uint16 ID, 
        uint16 amount, 
        address user
    ) public onlyGame {
        resources[user][ID] = amount;
        emit BuyResource(user, ID, amount);
    }

    //FOR STORE
    function addAmountOfOneResource(
        uint16 _ID, 
        uint16 _amount, 
        address _buyer
    ) public onlyStore {
        resources[_buyer][_ID] = resources[_buyer][_ID].add(_amount);
        emit BuyResource(_buyer, _ID, _amount);
    }

    function getResources(
        address user
    ) 
        public 
        view 
        returns 
        (uint32[] memory) 
    {
        uint32[] memory _resources = new uint32[](amountOfResources);
        for (uint16 i = 0; i < amountOfResources; i++){
            _resources[i] = resources[user][i];
        }
        return _resources;
    }

    function changeResourcesAmount(uint8 newAmount) public isOwner {
        amountOfResources = newAmount;
        emit ChangeResourcesAmount(newAmount);
    }

    function getResourcesAmount() public view returns (uint8) {
        return amountOfResources;
    }

}