----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: bone.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 26/06/2022
     Desc: Bone Utilities ]]--
----------------------------------------------------------------

--TODO: WIP

-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    isElement = isElement,
    getElementType = getElementType,
    setElementMatrix = setElementMatrix,
    setElementPosition = setElementPosition,
    getElementRotation = getElementRotation,
    getElementBoneMatrix = getElementBoneMatrix,
    setElementCollisionsEnabled = setElementCollisionsEnabled,
    Vector3 = Vector3,
    math = math,
    quat = quat,
    matrix = matrix
}


---------------------
--[[ Class: Bone ]]--
---------------------

bone = class.create("bone", {
    ids = {
        ped = {1, 2, 3, 4, 5, 6, 7, 8, 21, 22, 23, 24, 25, 26, 31, 32, 33, 34, 35, 36, 41, 42, 43, 44, 51, 52, 53, 54},
        vehicle = {}
    },
    cache = {
        element = {}
    },
    buffer = {
        element = {},
        parent = {}
    }
})

for i, j in imports.pairs(bone.ids) do
    local indexes = {}
    for k = 1, #j, 1 do indexes[(j[k])] = true end
    bone.ids[i] = indexes
end

function bone:create(...)
    local cBone = self:createInstance()
    if cBone and not cBone:load(...) then
        cBone:destroyInstance()
        return false
    end
    return cBone
end

function bone:destroy(...)
    if not self or (self == bone) then return false end
    return self:unload(...)
end

function bone:clearElementBuffer(element)
    if not element then return false end
    if bone.buffer.element[element] then
        bone.buffer.element[element]:destroy()
    end
    if bone.buffer.parent[element] then
        for i, j in imports.pairs(bone.buffer.parent[element]) do
            i:destroy()
        end
    end
    bone.buffer.parent[element] = nil
    return true
end

function bone:load(element, parent, boneData, remoteSignature)
    if not self or (self == bone) then return false end
    if not element or (not remoteSignature and not imports.isElement(element)) or not parent or (not remoteSignature and not imports.isElement(parent)) or not boneData or (element == parent) or bone.buffer.element[element] then return false end
    self.element = element
    self.parent = parent
    if not self:refresh(boneData, remoteSignature) then return false end
    self.cHeartbeat = thread:createHeartbeat(function()
        return not imports.isElement(element)
    end, function()
        imports.setElementCollisionsEnabled(element, false)
        self.cStreamer = streamer:create(element, "bone", {parent}, self.boneData.syncRate)
        self.cHeartbeat = nil
    end, settings.downloader.buildRate)
    bone.buffer.element[element] = self
    bone.buffer.parent[parent] = bone.buffer.parent[parent] or {}
    bone.buffer.parent[parent][self] = true
    return true
end

function bone:unload()
    if not self or (self == bone) or self.isUnloading then return false end
    self.isUnloading = true
    if self.cHeartbeat then
        self.cHeartbeat:destroy()
    end
    if self.cStreamer then
        self.cStreamer:destroy()
    end
    bone.cache.element[(self.element)] = nil
    bone.buffer.element[(self.element)] = nil
    self:destroyInstance()
    return true
end

function bone:refresh(boneData, remoteSignature)
    if not self or (self == bone) then return false end
    self.parentType = self.parentType or remoteSignature.parentType or imports.getElementType(self.parent)
    self.parentType = ((self.parentType == "player") and "ped") or self.parentType
    if not self.parentType or not bone.ids[(self.parentType)] then return false end
    boneData.id = imports.tonumber(boneData.id)
    if not boneData.id or not bone.ids[(self.parentType)][(boneData.id)] then return false end
    boneData.position, boneData.rotation = boneData.position or {}, boneData.rotation or {}
    boneData.position.x, boneData.position.y, boneData.position.z = imports.tonumber(boneData.position.x) or 0, imports.tonumber(boneData.position.y) or 0, imports.tonumber(boneData.position.z) or 0
    boneData.rotation.x, boneData.rotation.y, boneData.rotation.z = imports.tonumber(boneData.rotation.x) or 0, imports.tonumber(boneData.rotation.y) or 0, imports.tonumber(boneData.rotation.z) or 0
    if boneData.rotation.isRelative then
        local prev_rotX, prev_rotY, prev_rotZ = nil, nil, nil
        if self.boneData then prev_rotX, prev_rotY, prev_rotZ = self.boneData.rotation.x, self.boneData.rotation.y, self.boneData.rotation.z
        else prev_rotX, prev_rotY, prev_rotZ = remoteSignature.elementRotation or imports.getElementRotation(self.element, "ZYX") end
        local rotQuat = imports.quat.new(imports.quat.fromEuler(prev_rotX, prev_rotY, prev_rotZ))
        local __rotQuat = imports.quat.fromVectorAngle(imports.Vector3(1, 0, 0), boneData.rotation.x)*imports.quat.fromVectorAngle(imports.Vector3(0, 1, 0), boneData.rotation.y)*imports.quat.fromVectorAngle(imports.Vector3(0, 0, 1), boneData.rotation.z) 
        rotQuat = __rotQuat*rotQuat
        boneData.rotation.x, boneData.rotation.y, boneData.rotation.z = imports.quat.toEuler(rotQuat[1], rotQuat[2], rotQuat[3], rotQuat[4])
    end
    boneData.rotationMatrix = imports.matrix.fromRotation(boneData.rotation.x, boneData.rotation.y, boneData.rotation.z)
    boneData.syncRate = imports.tonumber(boneData.syncRate) or settings.streamer.boneSyncRate
    local isSyncRateModified = self.boneData and (self.boneData.syncRate ~= boneData.syncRate)
    self.boneData = boneData
    if isSyncRateModified then
        self.cStreamer.syncRate = self.boneData.syncRate
        self.cStreamer:deallocate()
        self.cStreamer:allocate()
    end
    return true
end

function bone:update()
    if not self or (self == bone) or self.cHeartbeat then return false end
    bone.cache.element[(self.parent)] = bone.cache.element[(self.parent)] or {}
    bone.cache.element[(self.parent)][(self.boneData.id)] = ((bone.cache.element[(self.parent)].streamTick == bone.cache.streamTick) and bone.cache.element[(self.parent)][(self.boneData.id)]) or imports.getElementBoneMatrix(self.parent, self.boneData.id)
    bone.cache.element[(self.parent)].streamTick = bone.cache.streamTick
    imports.setElementMatrix(self.element, imports.matrix.transform(bone.cache.element[(self.parent)][(self.boneData.id)], self.boneData.rotationMatrix, self.boneData.position.x, self.boneData.position.y, self.boneData.position.z))
    return true
end