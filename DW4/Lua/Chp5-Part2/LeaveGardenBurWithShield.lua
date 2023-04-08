-- Starts at the last lag frame after the castle section of Gardenbur after the Bakor fight
-- Manipulates getting the shield and exiting
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000 
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _toChambers()
	local result = c.WalkUp(15)
    c.WaitFor(10)
    c.UntilNextInputFrame()

    _tempSave(4)
	return true
end

local function _queensChambers()
	if not c.WalkUp(11) then return false end
    c.BringUpMenu()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    if not c.WalkDown(11) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    _tempSave(5)
	return true
end

local function _toBasement()
    local result = c.WalkMap({
        { ['Down'] = 8 },
        { ['Right'] = 6 },
        { ['Up'] = 7 },
        { ['Right'] = 3 },
        { ['Up'] = 9 },
        { ['Left'] = 9 },
        { ['Up'] = 3 },
        { ['Right'] = 4 },
    })
    if not result then return false end
    result = c.Best(c.WalkRightToCaveTransition, 5)
    if not c.Success(result) then return false end
    if not c.WalkRight(6) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    _tempSave(6)
    return true
end

local function _leaveBasement()
    if not c.WalkUp(2) then return false end
    if not c.BringUpMenu() then return false end
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1) 
    
    if not c.BringUpMenu() then return false end
    c.Item()
    if not c.PushAWithCheck() then return false end
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()

    -- Pick Copper Sword to discard, hero will not attack again until the zenithian sword is equipped
    if not c.PushAWithCheck() then return false end
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to nav to transfer') end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return c.Bail('Unable to nav to discard') end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.RandomFor(14)
    c.WaitFor(1)
    -----
    if not c.WalkUp(3) then return false end
    if not c.BringUpMenu() then return false end
    c.Search()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    if not c.WalkDown(5) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    _tempSave(7)
    return true
end

local function _leave()
    if not c.WalkLeft(6) then return false end
    local result = c.Best(c.WalkLeftToCaveTransition, 5)
    if not c.Success(result) then return false end
    result = c.WalkMap({
        { ['Left'] = 4 },
        { ['Up'] = 3 },
    })
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_toChambers, 10)
	if c.Success(result) then
        result = c.Best(_queensChambers, 10)
        if c.Success(result) then
            result = c.Best(_toBasement, 10)
            if c.Success(result) then
                result = c.Best(_leaveBasement, 10)
                if c.Success(result) then
                    result = c.Best(_leave, 10)
                    if c.Success(result) then
                        return true
                    end
                end
            end
        end
    end
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
	local result = c.Best(_do, 2)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



