----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: api: world: exports.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: World APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

manager:exportAPI("World", {
    shared = {},
    client = {
        {name = "clearWorld"},
        {name = "restoreWorld"},
        {name = "toggleOcclusions"},
        {name = "clearModel"},
        {name = "restoreModel"}
    },
    server = {}
})