-- Starts at the last lag frame after exiting gardenbur to the world map, with the Zenithian Shield
-- Manipulates returning to Mintos, sailing to Riverton and entering
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _toMintos()
    if not c.BringUpMenu() then return false end
    if not c.HeroCastReturn() then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to nav to Endor') end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return c.Bail('Unable to nav to Konenber') end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then return c.Bail('Unable to nav to Mintos') end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _toRiverton()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Left'] = 3 },
        { ['Up'] = 6 },
    })
    if not result then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 7 },
        { ['Up'] = 1 },
        { ['Left'] = 30 },
        { ['Down'] = 39 },
        { ['Right'] = 1 },
        { ['Down'] = 3 },
        { ['Right'] = 1 },
        { ['Down'] = 1 },
        { ['Right'] = 2 },
        { ['Down'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_toMintos, 9)
    if c.Success(result) then
	    result = c.Best(_toRiverton, 9)
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



