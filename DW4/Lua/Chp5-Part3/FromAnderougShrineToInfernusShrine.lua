-- Starts at the last lag frame after leaving the Anderoug shrine
-- Manipulates walking to the Infernus Shadow shrine
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leftSwamp()
    c.PushLeft()
    c.RandomFor(14)
    c.WaitFor(5)
    return not c.IsEncounter()
end

local function _do()
    local result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 2 },
        { ['Up'] = 3 },
        { ['Left'] = 3 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    if not c.Cap(_leftSwamp, 100) then return false end
    if not c.Cap(_leftSwamp, 100) then return false end
    if not c.Cap(_leftSwamp, 100) then return false end
    if not c.WalkLeft(4) then return false end
    if not c.Cap(_leftSwamp, 100) then return false end
    if not c.Cap(_leftSwamp, 100) then return false end
    if not c.Cap(_leftSwamp, 100) then return false end
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Up'] = 1 },
        { ['Left'] = 3 },
        { ['Up'] = 3 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 2 },
        { ['Left'] = 1 },
        { ['Up'] = 4 },
        { ['Left'] = 5 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 4 },
    })
    if not result then return false end
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
    local result = c.Best(_do, 25)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
