-- Starts at the last lag frame after entering floor 2 of the Cave of Betrayal
-- Manipulates getting to the Lic Lic encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor2()
    local result = c.WalkMap({
        { ['Up'] = 6 },
        { ['Left'] = 9 },
        { ['Up'] = 5 },
        { ['Left'] = 2 },
        { ['Up'] = 9 },
    })
    if not result then return false end
    result = c.BringUpMenu()
    if not result then return false end
    c.PushA() -- Talk
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(20)
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
    local result = c.Best(_floor2, 10)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
