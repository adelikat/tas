-- Starts at the last lag frame after entering gardenbur
-- Manipuklates entering the castle, going to jail with Ragnar left in jail, and exiting
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _enterCastle()
    local result = c.WalkUp(13)
    if not result then return false end
    c.BringUpMenu()
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _toThiefRoom()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 2 },
        { ['Up'] = 2 },
        { ['Right'] = 3 },
        { ['Up'] = 3 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.RandomFor(2)
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)

    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Up'] = 3 },
        { ['Left'] = 2 },
        { ['Up'] = 5 },
        { ['Right'] = 3 },
        { ['Up'] = 5 },
        { ['Left'] = 2 }
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _toQueen()
    local result = c.WalkLeft(3)
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    _tempSave(5)
    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
	local result = c.Cap(_toQueen, 20)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



