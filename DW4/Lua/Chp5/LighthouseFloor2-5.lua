-- Starts at the last lag frame after entering the 2nd floor of the light tower
-- Manipulates to the encounter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor2()
    local result = c.WalkMap({
        { ['Down'] = 9 },
        { ['Left'] = 2 },
        { ['Down'] = 5 },
     })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if c.IsEncounter() then
        return c.Bail('Got enounter')
    end
    
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 5 },
        { ['Up'] = 5 },
        { ['Right'] = 9 },
        { ['Down'] = 10 },
        { ['Left'] = 9 },
        { ['Down'] = 2 }
     })
    if not result then return false end
    result = c.Best(c.WalkDownToCaveTransition, 5)
    if not result then return false end
    local result = c.WalkMap({
        { ['Right'] = 13 },
        { ['Up'] = 2 },
        { ['Right'] = 3 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 11 },
        { ['Left'] = 4 },
        { ['Up'] = 4 },
        { ['Left'] = 8 },
        { ['Up'] = 5 },
     })
     if not result then return false end
     c.WaitFor(10)
     c.UntilNextInputFrame()
     if c.IsEncounter() then
        return c.Bail('Got enounter')
    end
    return true
end

local function _floor4()
    c.WalkDown(6)
    c.BringUpMenu()
    c.Search()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Right'] = 5 },
        { ['Up'] = 8 },
        { ['Right'] = 4 },
        { ['Up'] = 3 },
     })
     if not result then return false end
     c.WaitFor(10)
     c.UntilNextInputFrame()
     if c.IsEncounter() then
        return c.Bail('Got enounter')
    end
    return true
end

local function _floor5()
    local result = c.WalkMap({
        { ['Right'] = 4 },
        { ['Down'] = 11 },
        { ['Left'] = 7 },
        { ['Down'] = 7 },
        { ['Left'] = 3 },
        { ['Up'] = 7 },
     })
     if not result then return false end
     c.WaitFor(10)
     c.UntilNextInputFrame()
     c.AorBAdvance()
     c.AorBAdvance()
     c.WaitFor(1)
     c.DismissDialog()
     c.RandomFor(150)
     c.UntilNextInputFrame()
     c.AorBAdvance()
     c.WaitFor(1)
     c.RndAtLeastOne()
     c.WaitFor(10)
     c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_floor2, 12)
    if c.Success(result) then
        result = c.Best(_floor3, 12)
        if result then
            result = c.Best(_floor4, 12)
            if result then
                result = c.Best(_floor5, 12)
                if result then
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
    local result = c.Cap(_do, 5)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
