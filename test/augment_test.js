const GameContract = artifacts.require("Game");
const DigitalGolems = artifacts.require("DigitalGolems")
const AssetsContract = artifacts.require("Assets");
const Psychospheres = artifacts.require("Psychospheres")
const Inventory = artifacts.require("Inventory")
const Digibytes = artifacts.require("Digibytes")
const Store = artifacts.require("Store")
const { assert } = require("chai");
const {
    catchRevert,            
    catchOutOfGas,          
    catchInvalidJump,       
    catchInvalidOpcode,     
    catchStackOverflow,     
    catchStackUnderflow,   
    catchStaticStateChange
} = require("../../utils/catch_error.js")


contract('Game Augment', async (accounts)=>{
    let game;
    let inventory;
    let psycho;
    let store;
    let DIG;
    let assets;
    let user = accounts[9];
    let owner = accounts[0];
    let things = ["1","2","8","10","110"]
    let resources = ["2","3","1","4"]
    let augment = ["3","2","6","0","8","0","6","9","1"]
    const psychospheres = ["2", "3"]
    before(async () => {
        game = await GameContract.new()
        inventory = await Inventory.new()
        assets = await AssetsContract.new()
        DIG = await DigitalGolems.new()
        psycho = await Psychospheres.new()
        store = await Store.new()
        // await game.setDBT(DBT.address, {from: owner})
        await game.setDIG(DIG.address, {from: owner})
        await game.setInventory(inventory.address, {from: owner})
        await game.setAssets(assets.address, {from: owner})
        await game.setPsycho(psycho.address, {from:owner})
        await assets.setGame(game.address)
        await psycho.setGameContract(game.address)
        await inventory.setGameContract(game.address, {from:owner})
        await inventory.setStoreContract(store.address, {from:owner})
        await DIG.setGameAddress(game.address, {from: owner})
        await DIG.ownerMint(
            user,
            "tokenURIs",
            "0",
            "0"
        )
        await game.sessionResult(
            things,
            resources,
            augment,
            psychospheres,
            "1",
            user,
            {from: user}
        )
    })

    it("Should be new augment amount", async ()=>{
        let newAmount = "10";
        //changing Augmentations amount
        await inventory.changeAugmentationsAmount(newAmount, {from: owner})
        //adding more Augmentations, because we changed amount
        let newAugment = ["3","2","6","0","8","0","6","9","1","1"]
        await game.sessionResult(
            things,
            resources,
            newAugment,
            psychospheres,
            "1",
            user,
            {from: user}
        )
        //checking
        let getAugment = await inventory.getAugmentations(user, {from: user})
        assert.equal(getAugment.length, newAmount)
    })

}
)