-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()

function finishPreviousLevel()
    c.PushUp()
    c.PushUp()
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.PushSelect()
    c.WaitFor(3)
    if not emu.islagged() then
        c.Debug('pressing select did not cause the level select')
        return false
    end

    c.UntilNextInputFrame()
    c.PushStart()
    c.WaitFor(300)
    c.UntilNextLagFrame()
    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    return true
end

local giveUp = 10
c.Save('find-start')
local delay = 0
while not c.IsDone() do
    c.Load('find-start')
    console.log('full attempt with delay ' .. delay)
    c.WaitFor(delay)
    local result = finishPreviousLevel()
    if not result then
        delay = delay + 1
        if delay > giveUp then
            c.Done()
            console.log('-----GIVING UP----------')
        end
    else
         local result = c.FindSelectSkip('Right', 20 - delay)
        if (result) then
            c.Done()
        else
            console.log('FAIL, trying again!')
            delay = delay + 1
            if delay > giveUp then
                c.Done()
                console.log('-----GIVING UP----------')
            end
        end
    end
end

c.Finish()
