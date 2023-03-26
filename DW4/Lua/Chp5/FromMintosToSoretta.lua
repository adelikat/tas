
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
    c.WalkLeft(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _getCloseToSoretta()
    return c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 7 },
        { ['Up'] = 1 },
        { ['Right'] = 2 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 13 },
        { ['Down'] = 1 },
        { ['Right'] = 8 },
        { ['Down'] = 3 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 16 },
        { ['Down'] = 31 }
    }) 
end

local function _enterSoretta()
    local result = c.WalkRight(6)
    if not result then return false end
    c.WaitFor(10)  
    c.UntilNextInputFrame()
       
	return true
end

-- local function _toSoretta()
--     local result = c.Cap(_getCloseToSoretta, 10)
--     c.Best(_enterSoretta, 12)
--     return true
-- end

local function _goodStepsToCloseToSoretta()
    local result = c.Cap(_getCloseToSoretta, 100)
    if not result then
        return false
    end

    local steps = c.ReadStepCounter()
    c.Log('steps counter: ' .. steps)
    return steps <= 113
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	--local result = c.Best(_leave, 20)
    local result = true
    if c.Success(result) then
        result = c.Cap(_goodStepsToCloseToSoretta, 10000)	
        if c.Success(result) then
            c.Done()
        end
    end
    
end

c.Finish()



