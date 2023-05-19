-- TODO: leave casino has a bug and can get stuck on wing menu
-- Starts at the last lag frame after the hero enters Endor
-- For the first time, gets Nara and Mara and exits
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end



local function _intoCasino()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 8 },
        { ['Right'] = 6 },
        { ['Up'] = 4 },
        { ['Right'] = 4 },
        { ['Up'] = 1 },
    })

    if not result then return false end
    c.BringUpMenu()
    c.PushA() -- Talk
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.UntilNextMenuY()
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to sell')
    end
    c.PushA() -- Sell
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to clothes')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to hat')
    end
    c.PushA()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Yes
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.AorBAdvance()

    c.PushA() -- Yes
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Buy
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to antidote')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to fairy')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to wing')
    end
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushB() -- Cancel
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()

    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)    
    local result = c.WalkMap({
        { ['Left'] = 19 },
        { ['Down'] = 1 },
        { ['Left'] = 11 },
    })
    if not result then return false end

    c.PushUp()
    c.BringUpMenu()
    c.PushA() -- Talk
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()

    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)    
    result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 17 },
        { ['Down'] = 5 },
        { ['Left'] = 3 },
        { ['Down'] = 3 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _leaveCasino()
    result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Up'] = 9 },
        { ['Left'] = 8 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.PushA()
    c.BringUpMenu()
    c.PushA() -- Talk to Mara
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()

    result = c.BringUpMenu()
    if not result then return false end
    result = c.Item()
    if not result then return false end
    c.PushA() -- Pick Item
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Hero
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to clothes')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to wing')
    end
    c.PushA()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(2)
    c.UntilNextInputFrame()

    _tempSave(4)
    return true
end

local function _do()
    local result = c.Best(_intoCasino, 9)
    if c.Success(result) then
        --result = c.Best(_leaveCasino, 9)
        --if c.Success(result) then
            return true
        --end
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
    local result = c.Best(_leaveCasino, 12)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
