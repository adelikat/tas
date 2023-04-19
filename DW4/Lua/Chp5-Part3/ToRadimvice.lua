-- Starts at the last lag frame upon entering the dark world shrine that contains Radimvice
-- Manipulates getting into the boss encounter 
-- Notes: Hero max dmg with helm equipped: 
--  Regular: 56-63, Crit: min, easily more than 92 (near 146)
-- Hero no euip regular: 61-70
-- only Shield removed, crit: 144, easily enough
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Right'] = 3 },
        { ['Up'] = 7 },
        { ['Left'] = 3 },
        { ['Down'] = 2 },
    })    
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    if not c.BringUpMenu() then return false end
    if not c.Door() then return false end
    c.RandomForNoA(14)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Right'] = 3 },
        { ['Down'] = 4 },
        { ['Left'] = 9 },
        { ['Down'] = 1 },
    })
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    if not c.WalkUp(11) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    local result = c.WalkMap({
        { ['Down'] = 13 },
        { ['Right'] = 7 },
        { ['Up'] = 6 },
    })    
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_floor1, 9)
    if c.Success(result) then
        local result = c.Best(_floor2, 9)
        if c.Success(result) then
            local result = c.Best(_floor3, 9)
            if c.Success(result) then
                local result = c.Best(_floor4, 9)
                if c.Success(result) then
                    return true
                end
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
    local result = c.Best(_do, 2)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
