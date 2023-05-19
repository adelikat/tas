-- Starts at the last lag frame after entering Dire Palace
-- Manipulates use staff of transform to advance the plot, and casting return to Keeleon
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

-- Known good transforms:
-- 156, 163, 165, 166, 170, 185, 192, 194, 195, 196, 197

-- These won't trigger necrosaro
local _badTransforms = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [18] = 18,
    [23] = 23,
    [24] = 24,
    [54] = 54,
}

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _upStairs()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 1 },
        { ['Up'] = 9 },
        { ['Right'] = 6 },
        { ['Up'] = 4 },
        { ['Right'] = 6 },
        { ['Up'] = 3 },
        { ['Right'] = 5 },
        { ['Down'] =  3 }        
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
	return true
end

local function _transform()
    if not c.BringUpMenu() then return false end
    c.Item()
    if not c.PushAWithCheck() then return false end
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    c.WaitFor(1)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    c.RndLeftOrRight()
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return false end
    c.RndLeftOrRight()
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then return false end
    c.RndLeftOrRight()
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(2)
    c.UntilNextInputFrame()

    local transform = c.Read(0x6297)
    if _badTransforms[transform] ~= nil then
        return c.Bail('Bad transform: ' .. transform)
    end
    
	c.WaitFor(15)
    c.PushUp()
    c.RndWalkingFor('Up', 127)
    c.PushLeft()
    c.RndWalkingFor('Left', 127)
    c.PushDown()
    c.RndWalkingFor('Down', 127)
    c.PushLeft()
    c.RndWalkingFor('Left', 79)
    c.PushDown()
    c.RndWalkingFor('Down', 47)
    c.PushFor('Down', 17)
    c.RndWalkingFor('Down', 15)
    c.PushLeft()
    c.RndWalkingFor('Left', 15)
    c.PushDown()
    c.RndWalkingFor('Down', 31)

    c.PushFor('Left', 100)
    c.WaitFor(130)
    if not emu.islagged() then
        c.Log('Something went wrong')
        return false
    end
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(100)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.RandomFor(70)
    c.PushFor('Up', 12)
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushRight()
    c.RandomFor(15)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(15)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(15)
    c.WaitFor(1)
    c.PushUp()
    c.WaitFor(16)
    if not c.BringUpMenu() then return false end
    if not c.HeroCastReturn() then return false end
    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 16 then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_upStairs, 9)
    if c.Success(result) then
        result = c.Best(_transform, 12)
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
	local result = c.Best(_do, 10)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



