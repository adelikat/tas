-- Starts at the last lag frame upon exiting the cave west of kievs with the magic key
-- Manipulates entering Keeleon castle and then into the castle portion once inside
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _enterCastle()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Right'] = 7 },
        { ['Up'] = 5 },
        { ['Right'] = 10 },
        { ['Down'] = 3 },
        { ['Right'] = 2 },
        { ['Down'] = 1 },
        { ['Right'] = 9 },
        { ['Up'] = 2 },
        { ['Right'] = 3 },
        { ['Up'] = 7 },
        { ['Right'] = 2 },
        { ['Up'] = 10 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _enterCastlePortion()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 6 },
        { ['Up'] = 6 },
    })
    if not result then return false end
    c.BringUpMenu()
    result = c.Door()
    if not result then return false end
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _enterChambers()
    local result = c.WalkMap({
        { ['Right'] = 5 },
        { ['Up'] = 16 },
        { ['Left'] = 1 }
    })
    if not result then return false end
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(79)
    c.WaitFor(1)
    result = c.WalkLeft(4)
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(237)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(100)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(102)
    c.PushFor('Up', 10)
    result = c.WalkUp(2)
    if not result then return false end
    c.BringUpMenu()
    result = c.PushAWithCheck()
    if not result then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_enterCastle, 20)
    if c.Success(result) then
        local result = c.Best(_enterCastlePortion, 12)
        if c.Success(result) then
            local result = c.Best(_enterChambers, 12)
            if c.Success(result) then
                c.Done()
            end
        end
    end    
end

c.Finish()
