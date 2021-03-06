----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shared.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 26/06/2022
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    select = select,
    DoesEntityExist = DoesEntityExist,
    setmetatable = setmetatable,
    collectgarbage = collectgarbage,
    GetEntityMatrix = GetEntityMatrix,
    GetEntityCoords = GetEntityCoords,
    GetPlayerPed = GetPlayerPed,
    string = string,
    table = table,
    math = math
}
localPlayer = imports.GetPlayerPed(-1)


---------------
--[[ Utils ]]--
---------------

getElementPosition = function(element, offX, offY, offZ)
    if not offX or not offY or not offZ then
        return imports.GetEntityCoords(element)
    else
        if not element or not imports.DoesEntityExist(element) then return false end
        offX, offY, offZ = imports.tonumber(offX) or 0, imports.tonumber(offY) or 0, imports.tonumber(offZ) or 0
        local cMatrix = imports.GetEntityMatrix(element)
        return (offX*cMatrix[1][1]) + (offY*cMatrix[2][1]) + (offZ*cMatrix[3][1]) + cMatrix[4][1], (offX*cMatrix[1][2]) + (offY*cMatrix[2][2]) + (offZ*cMatrix[3][2]) + cMatrix[4][2], (offX*cMatrix[1][3]) + (offY*cMatrix[2][3]) + (offZ*cMatrix[3][3]) + cMatrix[4][3]
    end
end

getDistanceBetweenPoints2D = function(x1, y1, x2, y2)
    x1, y1, x2, y2 = imports.tonumber(x1), imports.tonumber(y1), imports.tonumber(x2), imports.tonumber(y2)
    if not x1 or not y1 or not x2 or not y2 then return false end
    return imports.math.sqrt(((x2 - x1)^2) + ((y2 - y1)^2))
end

getDistanceBetweenPoints3D = function(x1, y1, z1, x2, y2, z2)
    x1, y1, z1, x2, y2, z2 = imports.tonumber(x1), imports.tonumber(y1), imports.tonumber(z1), imports.tonumber(x2), imports.tonumber(y2), imports.tonumber(z2)
    if not x1 or not y1 or not z1 or not x2 or not y2 or not z2 then return false end
    return imports.math.sqrt(((x2 - x1)^2) + ((y2 - y1)^2) + ((z2 - z1)^2))
end


----------------------
--[[ Class: Class ]]--
----------------------

class = {
    create = function(type, parent)
        parent = (parent and (imports.type(parent) == "table") and parent) or {}
        parent.__C = {
            type = type,
            buffer = {}
        }
        parent.__index = parent
        function parent:getType(instance)
            if not self or ((self == parent) and (not instance or (imports.type(instance) ~= "table"))) then return false end
            instance = ((self ~= parent) and self) or instance
            return (instance.__C and instance.__C.type) or false
        end
        function parent:createInstance()
            if not self or (imports.type(self) ~= "table") or not self.__C or self.__isChild then return false end
            local instance = imports.setmetatable({}, {__index = self})
            instance.__isChild = true
            self.__C.buffer[instance] = true
            return instance
        end
        function parent:destroyInstance()
            if not self or (imports.type(self) ~= "table") or not self.__index or not self.__C or not self.__isChild then return false end
            self.__C.buffer[self] = nil
            self.__C = nil
            self.__isChild = nil
            self = nil
            imports.collectgarbage()
            return true
        end
        return parent
    end,

    destroy = function(instance)
        if not instance or (imports.type(instance) ~= "table") or not instance.__C or instance.__isChild then return false end
        for i, j in imports.pairs(instance.__C.buffer) do
            if i then
                i:destroyInstance()
            end
        end
        instance.__C = nil
        instance = nil
        imports.collectgarbage()
        return true
    end
}


---------------------
--[[ Class: File ]]--
---------------------

--TODO: WIP

---------------------
--[[ Class: UTF8 ]]--
---------------------

local __string_gsub = imports.string.gsub
string.gsub = function(string, matchWord, replaceWord, isStrictcMatch, matchPrefix, matchPostfix)
    matchPrefix, matchPostfix = matchPrefix or "", matchPostfix or ""
    matchWord = (isStrictcMatch and "%f[^"..matchPrefix.."%z%s]"..matchWord.."%f["..matchPostfix.."%z%s]") or matchPrefix..matchWord..matchPostfix
    return __string_gsub(string, matchWord, replaceWord)
end


----------------------
--[[ Class: Table ]]--
----------------------

table.insert = function(baseTable, index, value, isForced)
    if not baseTable or (imports.type(baseTable) ~= "table") then return false end
    if index and (isForced or (value ~= nil)) then
        index = imports.tonumber(index)
        if not index then return false end
    else
        value, index = index, nil
    end
    baseTable.__N = baseTable.__N or #baseTable
    index = index or (baseTable.__N + 1)
    if (index <= 0) or (index > (baseTable.__N + 1)) then return false end
    if index <= baseTable.__N then
        for i = baseTable.__N, index, -1 do
            baseTable[(i + 1)] = baseTable[i]
            baseTable[i] = nil
        end
    end
    baseTable[index] = value
    baseTable.__N = baseTable.__N + 1
    return true
end

table.remove = function(baseTable, index)
    index = imports.tonumber(index)
    if not baseTable or (imports.type(baseTable) ~= "table") or not index then return false end
    baseTable.__N = baseTable.__N or #baseTable
    if (index <= 0) or (index > baseTable.__N) then return false end
    baseTable[index] = nil
    if index < baseTable.__N then
        for i = index + 1, baseTable.__N, 1 do
            baseTable[(i - 1)] = baseTable[i]
            baseTable[i] = nil
        end
    end
    baseTable.__N = baseTable.__N - 1
    return true
end

table.pack = function(...)
    return {...}
end

table.unpack = function(baseTable)
    return imports.table.unpack(baseTable, 1, baseTable.__N or #baseTable)
end

table.clone = function(baseTable, isRecursive)
    if not baseTable or (imports.type(baseTable) ~= "table") then return false end
    local __baseTable = {}
    for i, j in imports.pairs(baseTable) do
        if (imports.type(j) == "table") and isRecursive then
            __baseTable[i] = table.clone(j, isRecursive)
        else
            __baseTable[i] = j
        end
    end
    return __baseTable
end


---------------------
--[[ Class: Math ]]--
---------------------

math.percent = function(amount, percent)
    amount, percent = imports.tonumber(amount), imports.tonumber(percent)
    if not percent or not amount then return false end
    return amount*percent*0.01
end

math.round = function(number, decimals)
    number = imports.tonumber(number)
    if not number then return false end
    decimals = imports.tonumber(decimals) or 0
    return imports.tonumber(imports.string.format("%."..decimals.."f", number))
end

math.findRotation2D = function(x1, y1, x2, y2) 
    x1, y1, x2, y2 = imports.tonumber(x1), imports.tonumber(y1), imports.tonumber(x2), imports.tonumber(y2)
    if not x1 or not y1 or not x2 or not y2 then return false end
    local rotAngle = -imports.math.deg(imports.math.atan2(x2 - x1, y2 - y1))
    return ((rotAngle < 0) and (rotAngle + 360)) or rotAngle
end

math.findDistRotationPoint2D = function(x, y, distance, angle)
    x, y, distance, angle = imports.tonumber(x), imports.tonumber(y), imports.tonumber(distance), imports.tonumber(angle)
    if not x or not y or not distance then return false end
    angle = angle or 0
    angle = imports.math.rad(90 - angle)
    return x + (imports.math.cos(angle)*distance), y + (imports.math.sin(angle)*distance)
end


---------------------
--[[ Class: Quat ]]--
---------------------

quat = {
    new = function(w, x, y, z)
        if not w or not x or not y or not z then return false end
        return imports.setmetatable({w, x, y, z}, quat)
    end,

    __add = function(quat1, quat2)
        if not quat1 or not quat2 then return false end
        return quat.new(quat1[1] + quat2[1], quat1[2] + quat2[2], quat1[3] + quat2[3], quat1[4] + quat2[4])
    end,

    __sub = function(quat1, quat2)
        if not quat1 or not quat2 then return false end
        return quat.new(quat1[1] - quat2[1], quat1[2] - quat2[2], quat1[3] - quat2[3], quat1[4] - quat2[4])
    end,

    __mul = function(quat1, quat2)
        if not quat1 or not quat2 then return false end
        return quat.new(
            (quat1[1]*quat2[1]) - (quat1[2]*quat2[2]) - (quat1[3]*quat2[3]) - (quat1[4]*quat2[4]),
            (quat1[1]*quat2[2]) + (quat1[2]*quat2[1]) + (quat1[3]*quat2[4]) - (quat1[4]*quat2[3]),
            (quat1[1]*quat2[3]) + (quat1[3]*quat2[1]) + (quat1[4]*quat2[2]) - (quat1[2]*quat2[4]),
            (quat1[1]*quat2[4]) + (quat1[4]*quat2[1]) + (quat1[2]*quat2[3]) - (quat1[3]*quat2[2])
        )
    end,

    __div = function(quat1, quat2)
        if not quat1 or not quat2 then return false end
        return quat.new(quat1[1]/quat2[1], quat1[2]/quat2[2], quat1[3]/quat2[3], quat1[4]/quat2[4])
    end,

    fromVectorAngle = function(vector, angle)
        if not vector or not angle then return false end
        local a = imports.math.rad(angle*0.5)
        local s, w = imports.math.sin(a), imports.math.cos(a)
        return quat.new(w, s*vector.x, s*vector.y, s*vector.z)
    end,

    fromEuler = function(x, y, z)
        if not x or not y or not z then return false end
        x, y, z = imports.math.rad(x)*0.5, imports.math.rad(y)*0.5, imports.math.rad(z)*0.5
        local sinX, sinY, sinZ = imports.math.sin(x), imports.math.sin(y), imports.math.sin(z)
        local cosX, cosY, cosZ = imports.math.cos(x), imports.math.cos(y), imports.math.cos(z)
        return (cosZ*cosX*cosY) + (sinZ*sinX*sinY), (cosZ*sinX*cosY) - (sinZ*cosX*sinY), (cosZ*cosX*sinY) + (sinZ*sinX*cosY), (sinZ*cosX*cosY) - (cosZ*sinX*sinY)
    end,

    toEuler = function(w, x, y, z)
        if not w or not x or not y or not z then return false end
        local sinX, sinY, sinZ = 2*((w*x) + (y*z)), 2*((w*y) - (z*x)), 2*((w*z) + (x*y))
        local cosX, cosY, cosZ = 1 - (2*((x*x) + (y*y))), imports.math.min(imports.math.max(sinY, -1), 1), 1 - (2*((y*y) + (z*z)))
        return imports.math.deg(imports.math.atan2(sinX, cosX)), imports.math.deg(imports.math.asin(cosY)), imports.math.deg(imports.math.atan2(sinZ, cosZ))
    end
}
quat.__index = quat


-----------------------
--[[ Class: Matrix ]]--
-----------------------

matrix = {
    fromPosition = function(posX, posY, posZ, rotX, rotY, rotZ)
        if not posX or not posY or not posZ or not rotX or not rotY or not rotZ then return false end
        rotX, rotY, rotZ = imports.math.rad(rotX), imports.math.rad(rotY), imports.math.rad(rotZ)
        local sYaw, cYaw = imports.math.sin(rotX), imports.math.cos(rotX)
        local sPitch, cPitch = imports.math.sin(rotY), imports.math.cos(rotY)
        local sRoll, cRoll = imports.math.sin(rotZ), imports.math.cos(rotZ)
        return {
            {(cRoll*cPitch) - (sRoll*sYaw*sPitch), (cPitch*sRoll) + (cRoll*sYaw*sPitch), -cYaw*sPitch, 0},
            {-cYaw*sRoll, cRoll*cYaw, sYaw, 0},
            {(cRoll*sPitch) + (cPitch*sRoll*sYaw), (sRoll*sPitch) - (cRoll*cPitch*sYaw), cYaw*cPitch, 0},
            {posX, posY, posZ, 1}
        }
    end,

    fromRotation = function(rotX, rotY, rotZ)
        if not rotX or not rotY or not rotZ then return false end
        rotX, rotY, rotZ = imports.math.rad(rotX), imports.math.rad(rotY), imports.math.rad(rotZ)
        local sYaw, cYaw = imports.math.sin(rotX), imports.math.cos(rotX)
        local sPitch, cPitch = imports.math.sin(rotY), imports.math.cos(rotY)
        local sRoll, cRoll = imports.math.sin(rotZ), imports.math.cos(rotZ)
        return {
            {(sRoll*sPitch*sYaw) + (cRoll*cYaw), sRoll*cPitch, (sRoll*sPitch*cYaw) - (cRoll*sYaw)},
            {(cRoll*sPitch*sYaw) - (sRoll*cYaw), cRoll*cPitch, (cRoll*sPitch*cYaw) + (sRoll*sYaw)},
            {cPitch*sYaw, -sPitch, cPitch*cYaw}
        }
    end,

    transform = function(elemMatrix, rotMatrix, posX, posY, posZ, isAbsoluteRotation, isDuplication)
        if not elemMatrix or not rotMatrix or not posX or not posY or not posZ then return false end
        if isAbsoluteRotation then
            if isDuplication then elemMatrix = table.clone(elemMatrix, true) end
            for i = 1, 3, 1 do
                for k = 1, 3, 1 do
                    elemMatrix[i][k] = 1
                end
            end
        end
        return {
            {
                (elemMatrix[2][1]*rotMatrix[1][2]) + (elemMatrix[1][1]*rotMatrix[1][1]) + (rotMatrix[1][3]*elemMatrix[3][1]),
                (elemMatrix[3][2]*rotMatrix[1][3]) + (elemMatrix[1][2]*rotMatrix[1][1]) + (elemMatrix[2][2]*rotMatrix[1][2]),
                (elemMatrix[2][3]*rotMatrix[1][2]) + (elemMatrix[3][3]*rotMatrix[1][3]) + (rotMatrix[1][1]*elemMatrix[1][3]),
                0
            },
            {
                (rotMatrix[2][3]*elemMatrix[3][1]) + (elemMatrix[2][1]*rotMatrix[2][2]) + (rotMatrix[2][1]*elemMatrix[1][1]),
                (elemMatrix[3][2]*rotMatrix[2][3]) + (elemMatrix[2][2]*rotMatrix[2][2]) + (elemMatrix[1][2]*rotMatrix[2][1]),
                (rotMatrix[2][1]*elemMatrix[1][3]) + (elemMatrix[3][3]*rotMatrix[2][3]) + (elemMatrix[2][3]*rotMatrix[2][2]),
                0
            },
            {
                (elemMatrix[2][1]*rotMatrix[3][2]) + (rotMatrix[3][3]*elemMatrix[3][1]) + (rotMatrix[3][1]*elemMatrix[1][1]),
                (elemMatrix[3][2]*rotMatrix[3][3]) + (elemMatrix[2][2]*rotMatrix[3][2]) + (rotMatrix[3][1]*elemMatrix[1][2]),
                (rotMatrix[3][1]*elemMatrix[1][3]) + (elemMatrix[3][3]*rotMatrix[3][3]) + (elemMatrix[2][3]*rotMatrix[3][2]),
                0
            },
            {
                (posZ*elemMatrix[1][1]) + (posY*elemMatrix[2][1]) - (posX*elemMatrix[3][1]) + elemMatrix[4][1],
                (posZ*elemMatrix[1][2]) + (posY*elemMatrix[2][2]) - (posX*elemMatrix[3][2]) + elemMatrix[4][2],
                (posZ*elemMatrix[1][3]) + (posY*elemMatrix[2][3]) - (posX*elemMatrix[3][3]) + elemMatrix[4][3],
                1
            }
        }
    end
}