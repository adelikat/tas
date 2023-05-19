-- Starts at the last lag frame after returning to Endor after getting the sword of decimation
-- Manipulates entering the Royal Crypt
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
    c.PushDown()
    c.RandomFor(16)
    c.UntilNextInputFrame()
    local result = c.WalkMap({
        { ['Down'] = 2 },
        { ['Right'] = 1 },
        { ['Down'] = 7 },
        { ['Left'] = 1 },
        { ['Down'] = 2 },
        { ['Left'] = 9 },
        { ['Down'] = 5 },
    })
     if not result then return false end
    c.PushDown()
    if not c.WalkDown(2) then return false end
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
	local result = c.Best(_do, 15)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



