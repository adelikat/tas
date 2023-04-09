-- Starts at the last lag frame after returning to Keelon after Dire Palace
-- Manipulates walking to and entering Aktemto to face Esturk
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
        { ['Left'] = 5 },
        { ['Up'] = 1 },
        { ['Left'] = 3 },
        { ['Up'] = 2 },
        { ['Left'] = 13 },
        { ['Up'] = 4 },
        { ['Left'] = 1 },
        { ['Up'] = 3 },
        { ['Left'] = 1 },
        { ['Up'] = 2 },
        { ['Left'] = 3 },
        { ['Up'] = 2 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 5 },
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
	local result = c.Best(_do, 12)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



