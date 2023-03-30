-- Starts at the last lag frame upon entering Mintos after delivering the pediquia seed
-- Manipulates getting Alena's party and returning to Soretta
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _inn()
    local result = c.WalkMap({
        { ['Right'] = 8 },
        { ['Up'] = 2 },
    })
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

local function _upStairs()
    local result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Left'] = 4 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _upStairs2()
    local result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Down'] = 1 },
    })
    if not result then return false end
    c.BringUpMenu()
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkDown(1)
    c.PushDown()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
    })
    if not result then return false end
    c.BringUpMenu()
    c.Item()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to clothes')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to symbol of faith')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Could not navigate to Padequia Root')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 3 },
    })
    if not result then return false end
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 9 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _return()
    c.BringUpMenu()
    c.HeroCastReturn()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Endor')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Konenber')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Mintos')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Unable to navigate to Soretta')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_inn, 10)
    if c.Success(result) then
        result = c.Best(_upStairs, 10)
        if c.Success(result) then
            result = c.Best(_upStairs2, 10)
            if c.Success(result) then
                result = c.Best(_return, 10)
                if c.Success(result) then
                    c.Done()
                end
            end
        end
    end
end

c.Finish()
