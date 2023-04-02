-- Starts at the last lag frame after returning to Endor from Keeleon
-- manipulates changing battle order to include Ragnar, and entering Santeem Castle
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    if not c.WalkDown() then return false end
    c.RandomFor(1)
    c.BringUpMenu()
    c.Tactics()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(18)
    if not c.PushAWithCheck() then return false end -- Pick Hero
    c.WaitFor(5)
    c.RandomFor(15)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Taloon
    c.WaitFor(5)
    c.RandomFor(15)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Taloon
    c.WaitFor(5)
    c.RandomFor(18)
    c.UntilNextInputFrame()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Cristo')
    end
    c.WaitFor(3)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to Nara')
    end
    c.WaitFor(3)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Could not navigate to Mara')
    end
    c.WaitFor(3)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Could not navigate to Brey')
    end
    c.WaitFor(3)
    c.PushDown()
    if c.ReadMenuPosY() ~= 21 then
        return c.Bail('Could not navigate to END')
    end
    c.WaitFor(1)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick END
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()

    c.RandomFor(11)
    c.PushFor('Right', 20)

    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Down'] = 9 },
        { ['Left'] = 4 },
        { ['Down'] = 2 },
        { ['Left'] = 67 },
        { ['Up'] = 36 },
        { ['Right'] = 6 },
    })
    c.PushUp()
    if not result then return false end
    result = c.WalkUp(5)
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_do, 25)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
