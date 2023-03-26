
-- Starts at the last lag frame after leaving Konenber with Taloon on the ship
-- Manipulates entering Mintos
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leave()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Down'] = 3 },
        { ['Left'] = 2 },
        { ['Down'] = 21 },
        { ['Right'] = 11 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
    })    
    if not result then return false end
    c.PushDown()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 3 },
        { ['Down'] = 4 },
    })    
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    
	return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.Best(_leave, 20)	
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



