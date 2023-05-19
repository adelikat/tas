-- Starts at the last lag frame after entering the Cave of Betrayal
-- Manipulates the first floor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 20 },
        { ['Right'] = 6 },
        { ['Up'] = 4 },
        { ['Right'] = 9 },
        { ['Down'] = 12 },
        { ['Right'] = 4 },
    })
    if not result then return false end
    c.PushFor('Down', 2)
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)

    result = c.WalkMap({
        { ['Down'] = 4 },
        { ['Right'] = 5 },
    })
    if not result then return false end

    c.WaitFor(10)
    c.UntilNextInputFrame()

    _tempSave(3)
    return true
end

c.Load(2)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_floor1, 10)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
