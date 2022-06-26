----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: timer.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 26/06/2022
     Desc: Timer Utilities ]]--
----------------------------------------------------------------

--TODO: WIP

-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    tonumber = tonumber,
    table = table,
    math = math,
    Citizen = Citizen
}


----------------------
--[[ Class: Timer ]]--
----------------------

timer = class.create("timer")

function timer:create(...)
    local cTimer = self:createInstance()
    if cTimer and not cTimer:load(...) then
        cTimer:destroyInstance()
        return false
    end
    return cTimer
end

function timer:destroy(...)
    if not self or (self == timer) then return false end
    return self:unload(...)
end

function timer:load(exec, interval, executions, ...)
    if not self or (self == timer) then return false end
    interval, executions = imports.tonumber(interval), imports.tonumber(executions)
    if not exec or (imports.type(exec) ~= "function") or not interval or not executions then return false end
    interval, executions = imports.math.max(1, interval), imports.math.max(0, executions)
    self.exec = exec
    self.currentExec = 0
    self.interval, self.executions = interval, executions
    self.arguments = imports.table.pack(...)
    self.timer = imports.setTimer(function()
        self.currentExec = self.currentExec + 1
        self.exec(imports.table.unpack(self.arguments))
        if (self.executions > 0) and (self.currentExec >= self.executions) then
            self:destroy()
        end
    end, self.interval, self.executions)
    return self
end

function timer:unload()
    if not self or (self == timer) then return false end
    if self.timer and imports.isTimer(self.timer) then
        imports.killTimer(self.timer)
    end
    self:destroyInstance()
    return true
end