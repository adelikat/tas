-- Starts at the last lag frame after exiting colossus
-- Manipulates entering dire palce
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.PushA()
    c.RandomFor(4)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 3 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 3 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 10 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 7 },
        { ['Down'] = 6 },
    })
    c.WaitFor(5)
    c.UntilNextInputFrame()

	return not c.IsEncounter()
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
	local result = c.Best(_do, 15)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



