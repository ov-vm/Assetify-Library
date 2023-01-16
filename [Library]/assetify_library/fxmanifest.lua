author "vStudio <crazynuggets@outlook.com>"
description "Assetify Library"
version "1.0.0"
fx_version "cerulean"
game "gta5"

shared_scripts {
    -->> Settings <<--
    "settings/shared.lua",

    -->> Utilities: Sandbox <<--
    "utilities/sandbox/index.lua",
    "utilities/sandbox/namespacer.lua",
    "utilities/sandbox/vcl.lua",
    "utilities/sandbox/table.lua",
    --"utilities/sandbox/filesystem.lua", --TODO: WIP
    "utilities/sandbox/math/index.lua",
    "utilities/sandbox/math/quat.lua",
    "utilities/sandbox/math/matrix.lua",
    "utilities/sandbox/string.lua",
    "utilities/sandbox/timer.lua",
    "utilities/sandbox/threader.lua",
    "utilities/sandbox/networker.lua",
    --"utilities/sandbox/rest.lua", --TODO: WIP
    --"utilities/engine/syncer.lua", --TODO: WIP
    --"utilities/sandbox/datasystem.lua"

    "test.lua", --TODO: REMOVE LATER
}

client_scripts {}

server_scripts {
    -->> Settings <<--
    "settings/server.lua"
}