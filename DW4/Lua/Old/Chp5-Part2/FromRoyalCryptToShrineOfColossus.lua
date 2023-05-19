-- Starts at the last lag frame after exiting the royal crypt
-- Manipulates casting return to Riverton, walks to the shrine of colossus and enters, and then enters into it
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _toRiverton()
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

local function _toShrine()
    c.ChargeUpWalking()
    if not c.WalkRight() then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.WalkDown() then return false end
    c.PushDown()
    local result = c.WalkMap({
        { ['Down'] = 4 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _enterShrine()
    local result = c.WalkMap({
        { ['Down'] = 6 },
        { ['Left'] = 3 },
        { ['Down'] = 3 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.Door() then return false end
    c.ChargeUpWalking()
    c.WalkLeft(4)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_toRiverton, 9)
    if c.Success(result) then
        result = c.Best(_toShrine, 9)
        if c.Success(result) then
            result = c.Best(_enterShrine, 9)
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



