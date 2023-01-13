fx_version "cerulean"
game "gta5"

description "Assetify Library"
version "1.0.0"

shared_scripts {
    -->> Settings <<--
    "settings/shared.lua"

    -->> Utilities: Sandbox <<--
    "utilities/sandbox/index.lua",
    "utilities/sandbox/namespacer.lua",
    "utilities/sandbox/vcl.lua", --TODO: WIP
    "utilities/sandbox/table.lua", --TODO: WIP
    "utilities/sandbox/filesystem.lua", --TODO: WIP
    "utilities/sandbox/math/index.lua",
    "utilities/sandbox/math/quat.lua",
    "utilities/sandbox/math/matrix.lua",
    "utilities/sandbox/string.lua", --TODO: WIP
    "utilities/sandbox/timer.lua", --TODO: WIP
    "utilities/sandbox/threader.lua", --TODO: WIP
    "utilities/sandbox/networker.lua", --TODO: WIP
    "utilities/sandbox/rest.lua", --TODO: WIP
    "utilities/engine/syncer.lua", --TODO: WIP
    "utilities/sandbox/datasystem.lua"
}

client_scripts {}

server_scripts {
    -->> Settings <<--
    "settings/server.lua"
}