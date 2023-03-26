
-- Starts at the last lag frame after the tower appears after the level ups
-- Manipulates using the fire of serentity, returning to Konenber and entering the town
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leave()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp(2)
	c.BringUpMenu()
    c.Item()
    c.PushA()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA() -- A
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to clothes')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to symbol of faith')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to the fire of serenity')
    end
    c.PushA()
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.PushA() -- Use
    c.RandomFor(2)
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(13)
    c.UntilNextInputFrame()

    c.PushRight()
    if c.ReadMenuPosY() ~= 32 then
        return c.Bail('Unable to navigate to spell')
    end
    c.PushA()
    c.WaitFor(6)
    c.UntilNextInputFrame()
    c.PushA() -- Pick A
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Return
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Endor')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to Konenber')
    end
    c.PushA() -- Pick Konenber
    c.RandomFor(2)
    c.WaitFor(100)
    c.UntilNextInputFrame()

    _tempSave(4)
	return true
end

local function _enterKonenber()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp(2)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	--local result = c.Best(_leave, 20)	
    local result = c.Best(_enterKonenber, 20)	
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



