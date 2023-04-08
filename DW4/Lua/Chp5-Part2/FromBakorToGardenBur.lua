-- Starts at the last lag frame after the bakor's room appears after the level-ups after the Bakor fight
-- Manipulates casting outside, returning to gardenbur, and entering
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _exitCave()
	c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(120)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.WaitFor(1)
    c.PushA()
    c.WaitFor(22)
    c.UntilNextInputFrame()
    c.HeroCastOutside()
	return true
end

local function _returnToGardenBur()
    c.BringUpMenu()
    c.HeroCastReturn()
    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then
        return c.Bail('Unable to navigate to arrow')
    end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Unable to navigate to Keeleon')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Santeem')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Gardenbur')
    end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(2)
    c.UntilNextInputFrame()
    return true
end

local function _enterGardenbur()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    return true
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

local function _do()
    local result = c.Best(_exitCave, 12)
    if c.Success(result) then
        local result = c.Best(_returnToGardenBur, 12)
        if c.Success(result) then
            local result = c.Best(_enterGardenbur, 12)
            if c.Success(result) then
                local result = c.Best(_enterCastle, 12)
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
	local result = c.Best(_do, 5)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



