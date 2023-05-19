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

local function _downStairs()
	c.RandomFor(20)
	c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(110)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(100)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(100)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(48)
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 9 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
	return true
end

local function _leave()
    local result = c.WalkMap({
        { ['Up'] = 7 },
        { ['Right'] = 6 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    if not c.WalkUp(2) then return false end
    c.WaitFor(1)
    c.UntilNextInputFrame()
    if not c.WalkUp() then return false end
    c.WaitFor(1)
    c.UntilNextInputFrame()
    if not c.WalkRight() then return false end
    if not c.BringUpMenu() then return false end
    c.Search()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    if not c.BringUpMenu() then return false end
    c.HeroCastReturn()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to naivaget to Endor')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to naivaget to Konenber')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to naivaget to Mintos')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Unable to naivaget to Soretta')
    end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_downStairs, 5)
    if c.Success(result) then
        result = c.Best(_leave, 5)
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
	local result = c.Best(_do, 5)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



