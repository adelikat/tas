-- Starts at the last lag frame upon returning to Stancia after Elfville
-- Manipulates taking the baloon to Monbaraba
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
        { ['Down'] = 1 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    local result = c.WalkMap({
        { ['Right'] = 12 },
        { ['Up'] = 45 },
    })
    if not result then return false end
    c.PushA()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.ChargeUpWalking()
    if not c.WalkUp() then return false end
    c.WaitFor(10)
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

    local result = c.Best(_do, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()

