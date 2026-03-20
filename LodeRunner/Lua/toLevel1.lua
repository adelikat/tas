-- Start in the lag frames immediately after power-off
dofile('lode-runner-core.lua')

if tastudio.engaged() then
    c.GoToFrame(0)
else
    if emu.framecount() > 8 then
        error('must be run at the beginning of the movie')
    end
end

c.Start()

function IncreaseSpeed(last)
    local speed = c.GameSpeed()
    c.PushAAndSelect()
    local newSpeed = c.GameSpeed()
    if newSpeed >= speed then
        error('failed to increase speed ' .. speed .. '-' .. newSpeed)
    end
    if not last then
        c.WaitFor(1)
    end
end

while not c.IsDone() do
    c.UntilNextInputFrame()
    c.PushStart()
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.PushFor('Select', 2)
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    for i = 1, 34 do
         IncreaseSpeed(i == 34)
    end

    c.PushStart()
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.UntilNextLagFrame()
    c.WaitFor(1)

    c.Marker('lv 1')
    c.Done()
end

c.Finish()
