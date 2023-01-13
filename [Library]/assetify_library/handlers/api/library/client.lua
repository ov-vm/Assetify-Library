----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: api: library: client.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: Library APIs ]]--
----------------------------------------------------------------


-----------------------
--[[ APIs: Library ]]--
-----------------------

function manager.API.Library.getDownloadProgress(...)
    return manager:getDownloadProgress(...)
end

function manager.API.Library.getResourceDownloadProgress(...)
    return manager:getResourceDownloadProgress(...)
end

function manager.API.Library.isAssetLoaded(...)
    return manager:isAssetLoaded(...)
end

function manager.API.Library.getAssetID(...)
    return manager:getAssetID(...)
end

function manager.API.Library.loadAsset(...)
    return manager:loadAsset(...)
end

function manager.API.Library.unloadAsset(...)
    return manager:unloadAsset(...)
end