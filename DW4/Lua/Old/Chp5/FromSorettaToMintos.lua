-- Starts at the last lag frame upon entering Soretta with the seed
-- Manipulates giving it to the king, returning to Mintos and entering
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _inn()
    local result = c.WalkMap({
        { ['Right'] = 3 },
        { ['Down'] = 3 },
    })
    if not result then return false end
    c.PushLeft()
    c.BringUpMenu()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.RandomFor(4)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.RandomFor(100)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    return true
end

local function _givePadequiaSeed()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Down'] = 4 },
        { ['Right'] = 3 },
        { ['Down'] = 3 },
        { ['Right'] = 17 },
        { ['Up'] = 2 },
    })
    if not result then return false end
    c.BringUpMenu()
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
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
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Could not pick Return')
    end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _enterMintos()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp()
    c.WaitFor(10)
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
        result = c.Best(_givePadequiaSeed, 10)
        if c.Success(result) then
            result = c.Best(_enterMintos, 30)
            if c.Success(result) then
                c.Done()
            end
        end
    end
end

c.Finish()
