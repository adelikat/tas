-- Starts at the last lag frame after returning to Soretta
-- Manipulates traveling to and entering the Shrine of Breaking Waves (to get the Zenithian Shield)
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
	c.RandomFor(13)
    c.WaitFor(1)
	
    local result = c.WalkMap({
        { ['Right'] = 3 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    local result = c.WalkMap({
        { ['Right'] = 5 },
        { ['Down'] = 88 },
        { ['Left'] = 3 },
        { ['Up'] = 2 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 7 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
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
	local result = c.Cap(_do, 10)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



