-- Starts at the first frame to advance the menu for the last stat of the last level up
-- after the Keelon fight
-- manipulates picking up Ragnar and casting return to Endor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(14)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Down'] = 3 },
        { ['Right'] = 5 }
    })
    if not result then return false end
    c.BringUpMenu()
    result = c.PushAWithCheck() -- Talk
    if not result then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(15)
    c.PushA()
    c.BringUpMenu()
    c.HeroCastReturn()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Endor')
    end
    result = c.PushAWithCheck()
    if not result then return false end
    c.RandomFor(2)
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
    local result = c.Best(_do, 40)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
