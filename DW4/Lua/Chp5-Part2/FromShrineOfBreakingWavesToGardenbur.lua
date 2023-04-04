-- Starts at the last lag frame after the chambets appear after level ups after defating balzack 2
-- Manipulates getting the magma staff and returning to Soretta
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
    local result = c.WalkMap({
        { ['Down'] = 5 },
        { ['Left'] = 5 },
        { ['Down'] = 2 },
        { ['Left'] = 14 },
        { ['Up'] = 5 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    c.PushLeft()
    local result = c.WalkMap({
        { ['Left'] = 22 },
        { ['Down'] = 3 },
        { ['Left'] = 2 },
        { ['Down'] = 1 },
        { ['Left'] = 2 },
        { ['Down'] = 18 },
        { ['Right'] = 1 },
        { ['Down'] = 1 },
        { ['Right'] = 9 },
        { ['Up'] = 6 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    c.Item()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to naivagate to Basic Clothes')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Symbol of Faith')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Lamp of Darkness')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Unable to navigate to Magic Key')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 21 then
        return c.Bail('Unable to navigate to Full Plate Armor')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 22 then
        return c.Bail('Unable to navigate to Magma Staff')
    end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(3)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 5 },
        { ['Up'] = 2 },
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
	local result = c.Best(_do, 25)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



