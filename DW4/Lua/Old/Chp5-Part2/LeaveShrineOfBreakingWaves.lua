-- Starts at the last lag frame after entering teh shrine of breaking waves
-- Manipulates getting the zenithian shield and casting outside
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _downStairs()
    local result = c.BringUpMenu()
    if not result then return false end
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)

    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 5 },
        { ['Up'] = 1 },
        { ['Right'] = 4 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 27 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 3 },
        { ['Left'] = 6 },
        { ['Down'] = 3 },
    })
    if not result then return false end

    result = c.Best(c.WalkDownToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Down'] = 9 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
        { ['Down'] = 5 },
        { ['Left'] = 2 },
        { ['Down'] = 3 },
        { ['Left'] = 2 },
        { ['Up'] = 2 },
        { ['Left'] = 1 },
        { ['Up'] = 4 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
        { ['Up'] = 4 },
        { ['Left'] = 2 },
        { ['Down'] = 1 },
        { ['Left'] = 2 },
    })
    if not c.Success(result) then return false end
    result = c.Best(c.WalkLeftToCaveTransition, 10)
    if not c.Success(result) then return false end
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 5 },
        { ['Left'] = 3 },
    })
    if not c.Success(result) then return false end
    c.PushDown()
    c.RandomFor(15)
    c.WaitFor(1)
    result = c.WalkDown(2)
    if not c.Success(result) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _leave()
    local result = c.WalkMap({
        { ['Left'] = 3 },
        { ['Up'] = 6 },
        { ['Left'] = 3 },
        { ['Up'] = 1 },
    })
    if not c.Success(result) then return false end
    if not c.BringUpMenu() then return false end
    c.Search()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    if not c.BringUpMenu() then return false end
    c.HeroCastOutside()
    _tempSave(5)
    return true
end

local function _do()
    local result = c.Best(_downStairs, 15)
    if c.Success(result) then
        result = c.Best(_leave, 15)
        if c.Success(result) then
            return true
        end
    end

    return false
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
	local result = c.Cap(_do, 1)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



