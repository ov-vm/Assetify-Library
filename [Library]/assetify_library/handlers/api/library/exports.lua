----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: api: library: exports.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: Library APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

manager:exportAPI("Library", {
    shared = {
        {name = "isLibraryBooted", API = "isBooted"},
        {name = "isLibraryLoaded", API = "isLoaded"},
        {name = "isModuleLoaded"},
        {name = "isResourceLoaded"},
        {name = "isResourceFlushed"},
        {name = "isResourceUnloaded"},
        {name = "getLibraryAssets", API = "fetchAssets"},
        {name = "getAssetData"},
        {name = "getAssetDep"},
        {name = "setElementAsset"},
        {name = "getElementAsset"},
        {name = "setGlobalData"},
        {name = "getGlobalData"},
        {name = "getAllGlobalDatas"},
        {name = "setEntityData"},
        {name = "getEntityData"},
        {name = "getAllEntityDatas"},
        {name = "setAttachment"},
        {name = "setDetachment"},
        {name = "clearAttachment"},
        {name = "createAssetDummy"},
        {name = "setBoneAttachment"},
        {name = "syncBoneDetachment"},
        {name = "setBoneRefreshment"},
        {name = "clearBoneAttachment"}
    },
    client = {
        {name = "getDownloadProgress"},
        {name = "getResourceDownloadProgress"},
        {name = "isAssetLoaded"},
        {name = "getAssetID"},
        {name = "loadAsset"},
        {name = "unloadAsset"}
    },
    server = {
        {name = "loadResource"}
    }
})