-- Starts at the last lag frame upon entering the dark world
-- Manipulates walking to the shrine that contains Radimvice
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 6 },
        { ['Right'] = 2 },
        { ['Up'] = 1 },
        { ['Right'] = 2 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 3 },
        { ['Up'] = 3 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 4 },
        { ['Right'] = 3 },
        { ['Up'] = 1 },
        { ['Right'] = 2 },
        { ['Up'] = 5 },
        { ['Right'] = 1 },
    })    
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
    local result = c.Cap(_do, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
