-- Starts at the last lag frame after exiting Gardenbur
-- Manipulates entering the Cave Southeast of Gardenbur
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

-- Ran this manually
local function _do()
    local result = c.WalkMap({
        { ['Down'] = 6 },
        { ['Right'] = 6 },
        { ['Down'] = 10 },
        { ['Right'] = 4 },
        { ['Down'] = 1 },
        { ['Right'] = 6 },
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
	local result = c.Best(_do, 12)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



