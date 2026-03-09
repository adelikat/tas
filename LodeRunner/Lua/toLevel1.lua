-- Start in the lag frames immediately after power-off
dofile('lode-runner-core.lua')

c.Load(0)

if emu.framecount() > 8 then
    error('tmust be run at the beginning of the movie')
end

c.Start()

c.Save('find-start')

function IncreaseSpeed()
    local speed = memory.readbyte(0x00E5)
    c.PushAAndSelect()
    local newSpeed = memory.readbyte(0x00E5)
    if newSpeed >= speed then
        error('failed to increase speed ' .. speed .. '-' .. newSpeed)
    end
    c.WaitFor(1)
end

while not c.IsDone() do
    c.UntilNextInputFrame()
    c.PushStart()
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.PushSelect()
    c.PushSelect()
    c.WaitFor(1)
    c.UntilNextInputFrame()


    for i = 1, 34 do
         IncreaseSpeed()
    end

    c.PushStart()
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.UntilNextLagFrame()
    c.WaitFor(1)
    c.UntilNextInputFrame()

    c.Done()
end

c.Finish()
