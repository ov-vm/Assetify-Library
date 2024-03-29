----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: index.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: Sandbox Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    tonumber = tonumber,
    getTickCount = getTickCount,
    GetPlayerPed = GetPlayerPed,
    GetEntityType = GetEntityType,
    DeleteEntity = DeleteEntity,
    getElementMatrix = getElementMatrix,
    getElementPosition = getElementPosition,
    TriggerServerEvent = TriggerServerEvent
}


---------------
--[[ Utils ]]--
---------------


localPlayer = (imports.TriggerServerEvent and imports.GetPlayerPed(-1)) or false
execFunction = function(exec, ...) if not exec or (imports.type(exec) ~= "function") then return false end; return exec(...) end
getElementType = function(element)
    local index = imports.GetEntityType(element)
    return ((index == 1) and "ped") or ((index == 2) and "vehicle") or ((index == 3) and "object") or false
end
isElement = function(element) return (element and getElementType(element) and true) or false end
destroyElement = function(element) return (isElement(element) and imports.DeleteEntity(element)) or false end

function getElementPosition(element, offX, offY, offZ)
    if not element or not isElement(element) then return false end
    if not offX or not offY or not offZ then
        return imports.getElementPosition(element)
    else
        offX, offY, offZ = imports.tonumber(offX) or 0, imports.tonumber(offY) or 0, imports.tonumber(offZ) or 0
        local cMatrix = imports.getElementMatrix(element)
        return (offX*cMatrix[1][1]) + (offY*cMatrix[2][1]) + (offZ*cMatrix[3][1]) + cMatrix[4][1], (offX*cMatrix[1][2]) + (offY*cMatrix[2][2]) + (offZ*cMatrix[3][2]) + cMatrix[4][2], (offX*cMatrix[1][3]) + (offY*cMatrix[2][3]) + (offZ*cMatrix[3][3]) + cMatrix[4][3]
    end
end

function getInterpolationProgress(tick, interval)
    if not tick or not interval then return false end
    return ((CLIENT_CURRENT_TICK or imports.getTickCount()) - tick)/interval
end