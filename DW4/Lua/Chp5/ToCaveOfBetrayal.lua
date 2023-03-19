-- Starts at the last lag frame after winging to Branca
-- Manipulates entering the Cave of Betrayal
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end



local function _nearCave()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Right'] = 14 },
        { ['Up'] = 4 },
        { ['Right'] = 40 },
        { ['Down'] = 5 },
        { ['Right'] = 5 },
        { ['Down'] = 2 },
        { ['Right'] = 3 },
        { ['Down'] = 1 },
        { ['Right'] = 7 },
    })

    if not result then return false end
    return true
end

local function _enterCave()
    c.WalkUp(5)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Cap(_nearCave, 100)
    if c.Success(result) then
        result = c.Best(_enterCave, 10)
        if c.Success(result) then
            return true
        end
    end

    return false
end

c.Load(2)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_do, 2)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
