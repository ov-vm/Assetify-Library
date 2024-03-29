----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: timer.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: Timer Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    tonumber = tonumber,
    Citizen = Citizen
}
Citizen = nil


----------------------
--[[ Class: Timer ]]--
----------------------

local timer = class:create("timer")

function timer.public:create(...)
    if self ~= timer.public then return false end
    local cTimer = self:createInstance()
    if cTimer and not cTimer:load(...) then
        cTimer:destroyInstance()
        return false
    end
    return cTimer
end

function timer.public:destroy(...)
    if not timer.public:isInstance(self) then return false end
    return self:unload(...)
end

function timer.public:load(exec, interval, executions, ...)
    if not timer.public:isInstance(self) then return false end
    interval, executions = imports.tonumber(interval), imports.tonumber(executions)
    if not exec or (imports.type(exec) ~= "function") or not interval or not executions then return false end
    interval, executions = math.max(1, interval), math.max(0, executions)
    self.exec = exec
    self.currentExec = 0
    self.interval, self.executions = interval, executions
    self.arguments = table.pack(...)
    imports.Citizen.CreateThread(function()
        while ((self.executions == 0) or (self.currentExec < self.executions)) do
            imports.Citizen.Wait(self.interval)
            if not timer.public:isInstance(self) then return end
            self.currentExec = self.currentExec + 1
            if (self.executions > 0) and (self.currentExec >= self.executions) then
                self:destroy()
            end
            self.exec(table.unpack(self.arguments))
        end
    end)
    return self
end

function timer.public:unload()
    if not timer.public:isInstance(self) then return false end
    self:destroyInstance()
    return true
end