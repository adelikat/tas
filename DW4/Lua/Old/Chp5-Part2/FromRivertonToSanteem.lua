-- Starts at the last lag frame upon entering Riverton with the gas-canister
-- Manipulates getting the baloon and casting return to Santeem
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _toInn()
    local result = c.WalkMap({
        { ['Up'] = 16 },
        { ['Left'] = 2 },
        { ['Up'] = 11 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.PushUp()
    c.RandomFor(15)
    c.WaitFor(1)
    if not c.WalkUp(3) then return false end
    c.PushLeft()
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()

    c.ChargeUpWalking()
    if not c.WalkDown(4) then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    result = c.WalkMap({
        { ['Right'] = 6 },
        { ['Down'] = 8 },
        { ['Right'] = 1 },
    })
    c.PushRight()
    c.RandomFor(15)
    c.WaitFor(1)
    if not c.WalkRight(3) then return false end

    -- Due to timing of scripted NPC movement, this is the same number of frames
    -- as if you did not push A to pre-charge a menu, and stopped and waiting for the inn keeper
    result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Up'] = 1 },
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
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(10) -- Magic frame in here
    c.UntilNextInputFrame()
    return true
end

local function _leave()
    c.WaitFor(2)
    c.DismissDialog()
    c.ChargeUpWalking()
    if not c.WalkLeft(4) then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Up'] = 12 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    c.PushLeft()
    c.RandomFor(15)
    c.WaitFor(1)
    if not c.WalkLeft(3) then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    if not c.BringUpMenu() then return false end
    c.HeroCastReturn()
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
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_toInn, 8)
    if c.Success(result) then
        local result = c.Best(_leave, 8)
        if c.Success(result) then
            return true
        end
    end
end

c.Load(2)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)

    local result = c.Cap(_do, 8)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
