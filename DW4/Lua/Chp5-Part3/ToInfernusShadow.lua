-- Starts at the last lag frame after entering the Infernus Shadow shrine
-- Manipulates walking to the Infernus Shadow and starting the encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 1 },
        { ['Up'] = 3 },
    })
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true    
end

local function _floor2()
    if not c.WalkUp(9) then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    return true
end

local function _do()
    local result = c.Best(_floor1, 10)
    if c.Success(result) then
        local result = c.Best(_floor2, 10)
        if c.Success(result) then
            return true
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
