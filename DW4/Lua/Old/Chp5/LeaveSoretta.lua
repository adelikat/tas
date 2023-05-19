
-- Starts at the last lag frame after entering soretta
-- Manipulates staying at the inn and casting return to Endor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _leave()
    c.WalkRight(3)
    c.WalkDown(3)
    c.PushLeft()
    c.BringUpMenu()
    c.PushA() -- Talk
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.RandomFor(2)
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.BringUpMenu()
    c.PushRight()
    if c.ReadMenuPosY() ~= 32 then
        return c.Bail('Unable to navigate to spell')
    end
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Endor')
    end
    c.PushA()
    c.RandomFor(2)
    c.UntilNextInputFrame()


    _tempSave(4)
    return true
end


c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.Best(_leave, 20)
    local result = true
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()



