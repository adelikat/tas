-- Starts at the last lag frame after entering Riverton, to get a save point (after getting Zenithian shield)
-- Manipulates returning to Konenber and entering
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _toKonenber()
    if not c.BringUpMenu() then return false end
    if not c.HeroCastReturn() then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to nav to Endor') end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return c.Bail('Unable to nav to Konenber') end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _enter()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_toKonenber, 10)
    if c.Success(result) then
	    result = c.Best(_enter, 10)
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



