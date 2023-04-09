-- Starts at the first frame to dimiss the "Terrific Blow" dialog, manipulates to 
-- Manipulates reviving and returning to Riverton, and entering
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _revive()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(50)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    return true
end

local function _return()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    if not c.BringUpMenu() then return false end
    if not c.HeroCastReturn() then return false end
    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 16 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _enter()
    c.ChargeUpWalking()
    c.PushRight()
    c.RandomFor(16)
    c.UntilNextInputFrame()
    c.PushUp()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_revive, 12)
    if c.Success(result) then
        local result = c.Best(_return, 12)
        if c.Success(result) then
            local result = c.Best(_enter, 15)
            if c.Success(result) then
                return true
            end
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
