----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: renderer.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 26/06/2022
     Desc: Renderer Utilities ]]--
----------------------------------------------------------------

--TODO: WIP

-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    tonumber = tonumber,
    getTickCount = getTickCount,
    isElement = isElement,
    destroyElement = destroyElement,
    guiGetScreenSize = guiGetScreenSize,
    addEventHandler = addEventHandler,
    removeEventHandler = removeEventHandler,
    dxCreateScreenSource = dxCreateScreenSource,
    dxCreateRenderTarget = dxCreateRenderTarget,
    dxUpdateScreenSource = dxUpdateScreenSource
}


-------------------------
--[[ Class: Renderer ]]--
-------------------------

renderer = class.create("renderer", {
    cache = {
        isVirtualRendering = false,
        isTimeSynced = false,
        serverTick = 60*60*12,
        minuteDuration = 60
    }
})

if localPlayer then
    renderer.resolution = {imports.guiGetScreenSize()}
    renderer.resolution[1], renderer.resolution[2] = renderer.resolution[1]*settings.renderer.resolution, renderer.resolution[2]*settings.renderer.resolution

    renderer.render = function()
        imports.dxUpdateScreenSource(renderer.cache.virtualSource)
        return true
    end

    function renderer:syncShader(syncShader)
        if not syncShader then return false end
        renderer:setVirtualRendering(_, _, syncShader, syncer.librarySerial)
        renderer:setTimeSync(_, syncShader, syncer.librarySerial)
        renderer:setServerTick(_, syncShader, syncer.librarySerial)
        renderer:setMinuteDuration(_, syncShader, syncer.librarySerial)
        return true
    end

    function renderer:setVirtualRendering(state, rtModes, syncShader, isInternal)
        if not syncShader then
            state = (state and true) or false
            rtModes = (rtModes and (imports.type(rtModes) == "table") and rtModes) or false
            if renderer.cache.isVirtualRendering == state then return false end
            renderer.cache.isVirtualRendering = state
            if renderer.cache.isVirtualRendering then
                renderer.cache.virtualSource = imports.dxCreateScreenSource(renderer.resolution[1], renderer.resolution[2])
                renderer.cache.virtualRTs = renderer.cache.virtualRTs or {}
                if rtModes.diffuse then
                    renderer.cache.virtualRTs.diffuse = imports.dxCreateRenderTarget(renderer.resolution[1], renderer.resolution[2], true)
                    if rtModes.emissive then
                        renderer.cache.virtualRTs.emissive = imports.dxCreateRenderTarget(renderer.resolution[1], renderer.resolution[2], false)
                    end
                end
                imports.addEventHandler("onClientHUDRender", root, renderer.render)
            else
                imports.removeEventHandler("onClientHUDRender", root, renderer.render)
                if renderer.cache.virtualSource and imports.isElement(renderer.cache.virtualSource) then
                    imports.destroyElement(renderer.cache.virtualSource)
                end
                renderer.cache.virtualSource = nil
                for i, j in imports.pairs(renderer.cache.virtualRTs) do
                    if j and imports.isElement(j) then
                        imports.destroyElement(j)
                    end
                    renderer.cache.virtualRTs[i] = nil
                end
            end
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer:setVirtualRendering(_, _, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            local vSource0, vSource1, vSource2 = (renderer.cache.isVirtualRendering and renderer.cache.virtualSource) or false, (renderer.cache.isVirtualRendering and renderer.cache.virtualRTs.diffuse) or false, (renderer.cache.isVirtualRendering and renderer.cache.virtualRTs.emissive) or false
            syncShader:setValue("vResolution", (renderer.cache.isVirtualRendering and renderer.resolution) or false)
            syncShader:setValue("vRenderingEnabled", (renderer.cache.isVirtualRendering and true) or false)
            syncShader:setValue("vSource0", vSource0)
            syncShader:setValue("vSource1", vSource1)
            syncShader:setValue("vSource1Enabled", (vSource1 and true) or false)
            syncShader:setValue("vSource2", vSource2)
            syncShader:setValue("vSource2Enabled", (vSource2 and true) or false)
        end
        return true
    end

    function renderer:setTimeSync(state, syncShader, isInternal)
        if not syncShader then
            state = (state and true) or false
            if renderer.cache.isTimeSynced == state then return false end
            renderer.cache.isTimeSynced = state
            if not renderer.cache.isTimeSynced then
                renderer:setServerTick(((renderer.cache.serverTick or 0)*1000) + (imports.getTickCount() - (renderer.cache.__serverTick or 0)))
            end
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer:setTimeSync(_, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            syncShader:setValue("gTimeSync", renderer.cache.isTimeSynced)
        end
        return true
    end

    function renderer:setServerTick(serverTick, syncShader, isInternal)
        if not syncShader then
            renderer.cache.serverTick = (imports.tonumber(serverTick) or 0)*0.001
            renderer.cache.__serverTick = imports.getTickCount()
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer:setServerTick(_, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            syncShader:setValue("gServerTick", renderer.cache.serverTick)
        end
        return true
    end

    function renderer:setMinuteDuration(minuteDuration, syncShader, isInternal)
        if not syncShader then
            renderer.cache.minuteDuration = (imports.tonumber(minuteDuration) or 0)*0.001
            for i, j in imports.pairs(shader.buffer.shader) do
                renderer:setMinuteDuration(_, i, syncer.librarySerial)
            end
        else
            local isExternalResource = sourceResource and (sourceResource ~= syncer.libraryResource)
            if (not isInternal or (isInternal ~= syncer.librarySerial)) and isExternalResource then
                return false
            end
            syncShader:setValue("gMinuteDuration", renderer.cache.minuteDuration)
        end
        return true
    end
end