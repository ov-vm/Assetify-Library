print("Testing Timer, Creating a timer that executes 5 times every 1 second")
timer:create(function()
    print("Timer Executed")
end, 1000, 5)
