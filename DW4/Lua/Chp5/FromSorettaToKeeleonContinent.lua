-- Starts at the last lag frame upon entering Mintos after delivering the pediquia seed
-- Manipulates getting Alena's party and returning to Soretta
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _pick4th()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Nara')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Mara')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to 4th person')
    end
    c.WaitFor(2)
    c.PushAWithCheck()
    c.RandomFor(30)
    c.UntilNextInputFrame()
    return true
end

local function _toWater()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.BringUpMenu()
    c.Tactics()
    c.PushAWithCheck()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushAWithCheck()
    c.RandomFor(1) -- Magic frame
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    local result = _pick4th()
    if not result then return false end
    local result = _pick4th()
    if not result then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Nara')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Mara')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Taloon')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Unable to navigate to Brey')
    end
    c.WaitFor(2)
    c.PushAWithCheck()
    c.RandomFor(26)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Nara')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Mara')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Taloon')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then
        return c.Bail('Unable to navigate to END')
    end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushAWithCheck()
    c.RandomFor(15)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(29)
    c.WaitFor(1)
    result = c.WalkMap({
        { ['Right'] = 3 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    _tempSave(4)
    return true
end



c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_toWater, 10)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
