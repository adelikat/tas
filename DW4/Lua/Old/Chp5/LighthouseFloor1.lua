-- Starts at the last lag frame after entering the light tower
-- Manipulates the first floor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 1 },
     })
    if not result then return false end
    c.BringUpMenu()
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Right'] = 2 },
        { ['Up'] = 4 },
        { ['Right'] = 1 },
        { ['Up'] = 2 },
        { ['Right'] = 6 },
        { ['Up'] = 8 },
        { ['Left'] = 6 },
        { ['Up'] = 4 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
     })
     c.RandomFor(51)
     c.UntilNextInputFrame()
     c.AorBAdvance()
     c.AorBAdvance()
     c.AorBAdvance()
     c.WaitFor(2)
     c.UntilNextInputFrame()
     c.PushA()
     c.WaitFor(10)
     c.UntilNextInputFrame()
     c.AorBAdvance()
     c.AorBAdvance()
     c.AorBAdvance()
     c.AorBAdvance()
     c.WaitFor(2)
     c.UntilNextInputFrame()
     c.PushB()
     c.WaitFor(20)
     c.UntilNextInputFrame()
     c.WaitFor(1)
     c.DismissDialog()
     c.RandomFor(200)
     c.WaitFor(1)
     c.PushFor('Up', 54)
     c.WalkUp(3)
     c.WaitFor(10)
     c.UntilNextInputFrame()
     if c.IsEncounter() then
        return false
     end
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_do, 12)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
