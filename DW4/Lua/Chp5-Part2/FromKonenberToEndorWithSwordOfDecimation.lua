-- Starts at the last lag frame after entering Konenber, to get the sword of decimation
-- Manipulates getting the sword, equipping, and returning to Endor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _upStairs()
    local result = c.WalkMap({
        { ['Left'] = 6 },
        { ['Down'] = 3 },
        { ['Left'] = 4 },
        { ['Down'] = 2 },
        { ['Left'] = 3 },
        { ['Down'] = 4 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _leave()
    if not c.WalkUp(5) then return false end
    c.PushRight()
    c.BringUpMenu()
    if not c.Door() then return false end
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Up'] = 1 },
        { ['Right'] = 3 },
    })
    if not c.BringUpMenu() then return false end
    if not result then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    if not c.BringUpMenu() then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to nav to Status') end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return c.Bail('Unable to nav to Equip') end
    if not c.PushAWithCheck() then return false end
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to nav to Taloon') end
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to nav to Sword of Dec.') end
    c.WaitFor(1)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(8)
    c.UntilNextInputFrame()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.PushB()
    c.WaitFor(1)
    if c.ReadMenuPosY() ~= 18 then return c.Bail('Lag while pressing B') end
    c.RandomFor(5)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.PushB()
    c.WaitFor(1)
    if c.ReadMenuPosY() ~= 18 then return c.Bail('Lag while pressing B') end
    c.UntilNextInputFrame()
    if not c.BringUpMenu() then return false end
    if not c.HeroCastReturn() then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to nav to Endor') end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_upStairs, 9)
    if c.Success(result) then
	    result = c.Best(_leave, 9)
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
    local result = c.Best(_do, 4)
    if c.Success(result) then
        c.Done()
	end
end

c.Finish()



