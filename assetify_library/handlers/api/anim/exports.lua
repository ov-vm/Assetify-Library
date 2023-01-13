----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: api: anim: exports.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: Anim APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

manager:exportAPI("Anim", {
    shared = {},
    client = {
        {name = "loadAnim"},
        {name = "unloadAnim"}
    },
    server = {}
})