-- Starts at the last lag frame after entering Hector's shrine
-- Manipulates exit
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _enterShrine()
    local result = c.WalkMap({
        { ['Right'] = 12 },
        { ['Down'] = 2 },
        { ['Right'] = 7 },
        
    })
    if not result then return false end
    c.PushUp()
    c.BringUpMenu()
    c.PushA()
    c.RandomFor(15)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.RandomFor(2)
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Left'] = 7 },
        { ['Up'] = 1 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
    })    
    if not result then return false end
    c.BringUpMenu()
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
    })    
    if not result then return false end
    c.BringUpMenu()
    c.PushA()
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(350)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(130)
    c.UntilNextInputFrame()

    _tempSave(4)
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_enterShrine, 12)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
