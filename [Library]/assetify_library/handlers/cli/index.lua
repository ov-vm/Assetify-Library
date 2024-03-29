----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: cli: index.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 13/01/2023
     Desc: CLI Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addCommandHandler = addCommandHandler,
    outputServerLog = outputServerLog
}


--------------------
--[[ Class: CLI ]]--
--------------------

local cli = class:create("cli")
function cli.public:import() return cli end
cli.private.validActions = {
    ["uid"] = true,
    ["version"] = true,
    ["update"] = true
}


----------------------
--[[ CLI Handlers ]]--
----------------------

function cli.public:uid(isAction)
    imports.outputServerLog("Assetify: UID ━│  "..syncer.librarySerial)
    return true
end

function cli.public:version(isAction)
    imports.outputServerLog("Assetify: Version ━│  "..(syncer.libraryVersion or "N/A"))
    return true
end


---------------------
--[[ CLI Syncers ]]--
---------------------

imports.addCommandHandler("assetify", function(isConsole, _, isAction, ...)
    if not isConsole or (getElementType(isConsole) ~= "console") then return false end
    isAction = (isAction and ((string.sub(isAction, 0, 2) == "--") and string.sub(isAction, 3, #isAction))) or false
    if not isAction or not cli.private.validActions[isAction] then return false end
    cli.public[isAction](_, true, ...)
end)