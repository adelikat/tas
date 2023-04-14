-- Starts at the last lag frame upon entering Stancia
-- Manipulates talking to someone that will trigger the ability to pick up Panon, and then casting return to Soretta
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.ChargeUpWalking()
    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    c.PushA()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    local result = c.WalkMap({
        { ['Up'] = 57 },
        { ['Left'] = 6 },
    })
    if not result then return false end
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.ChargeUpWalking()
    c.PushLeft()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    return true
end


c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)

    local result = c.Best(_do, 20)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
