--[[
print("Testing Timer, Creating a timer that executes 5 times every 1 second")
timer:create(function()
    print("Timer Executed")
end, 1000, 5)
]]

--[[
print("Testing Thread, Creating a thread that pauses for 2.5 seconds after every print")
thread:create(function()
    print("First Print")
    print(">>> Going to sleep now")
    sleep(2500)

    print(">>> Wokeup")
    print("Second Print")
    print(">>> Going to sleep now")
    sleep(2500)

    print(">>> Wokeup")
    print("Third Print")
    print(">>> Going to sleep now")
    sleep(2500)

    print(">>> Wokeup")
    print("Fourth Print")
    print(">>> Going to sleep now")
    sleep(2500)

    print(">>> Wokeup")
    print("Fifth Print")
    print(">>> Going to sleep now")
    sleep(2500)

    print("Finished thread execution completely!")
end):resume()
]]

if localPlayer then
    print("Booted Client Sided Network")
    print("Trying to emit to custom server network 'Hello World'")
    network:emit("testnetwork", false, "Hello", "World")
else
    print("Booted Server Sided Network")
    network:create("testnetwork"):on(function(...)
        iprint(...)
    end)
end