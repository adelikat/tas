-- Starts at the last lag frame after entering Balzack's chambers
-- manipulates walking to him and starting the fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 3 },
        { ['Right'] = 1 },
        { ['Up'] = 6 },
    })
    if not result then return false end

    -- Transfer Sword of Malice to Taloon
    c.BringUpMenu()
    c.Item()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Taloon')
    end
    c.WaitFor(10)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Ragnar')
    end
    c.WaitFor(9)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Leather Armor')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Sword of Malice')
    end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Transfer')
    end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Taloon')
    end
    c.WaitFor(9)    
    if not c.PushAWithCheck() then return false end
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()

    -- Equip Taloon with Sword of Malice (necessary since you cannot tell the AI controlled players to do this in battle)
    c.BringUpMenu()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Equip')
    end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Taloon')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(20)
    c.UntilNextInputFrame()

    c.PushUp()
    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Unable to navigate to Sword of Malice')
    end
    c.WaitFor(1)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(17)
    c.UntilNextInputFrame()
    c.PushB()
    c.WaitFor(1)
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate back Sword of Malice')
    end
    c.RandomFor(15)
    c.UntilNextInputFrame()
    c.PushB()
    c.WaitFor(1)
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate back from Sword of Malice')
    end    
    c.UntilNextInputFrame()

    result = c.BringUpMenu()
    if not result then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(20)
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
    local result = c.Best(_do, 25)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
