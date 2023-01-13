----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: api: sound: exports.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: Sound APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

manager:exportAPI("Sound", {
    shared = {},
    client = {
        {name = "playSoundAsset", API = "playSound"},
        {name = "playSoundAsset3D", API = "playSound3D"}
    },
    server = {}
})