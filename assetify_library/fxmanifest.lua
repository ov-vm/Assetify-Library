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
    "utilities/sandbox/vcl.lua",
    "utilities/sandbox/table.lua",
    "utilities/sandbox/filesystem.lua",
    "utilities/sandbox/math/index.lua",
    "utilities/sandbox/math/quat.lua",
    "utilities/sandbox/math/matrix.lua",
    "utilities/sandbox/string.lua",
    "utilities/sandbox/timer.lua",
    "utilities/sandbox/threader.lua",
    "utilities/sandbox/networker.lua",
    "utilities/sandbox/rest.lua",
    "utilities/engine/syncer.lua",
    "utilities/sandbox/datasystem.lua",
}

client_scripts {
    "client/main.lua",
    "client/functions.lua",
    "client/loops.lua",
    "client/events.lua",
    "client/drawtext.lua"
}

server_scripts {
    -->> Settings <<--
    "settings/server.lua"
}