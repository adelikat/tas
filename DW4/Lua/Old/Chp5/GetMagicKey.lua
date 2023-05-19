-- Starts at the last lag frame upon entering the cave west of kievs to get the magic key
-- Dragonpup and Bisonbear are known enemy types that can do this and come in parties of 3
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    local result = c.WalkMap({
        { ['Down'] = 2 },
        { ['Right'] = 2 }
    })

    if not result then return false end

    result = c.Best(c.WalkRightToCaveTransition, 10)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Up'] = 9 },
        { ['Left'] = 10 },
        { ['Up'] = 2 },
        { ['Left'] = 7 },
        { ['Up'] = 8 },
        { ['Right'] = 7 },
        { ['Up'] = 4 },
        { ['Right'] = 8 },
        { ['Up'] = 7 },
      })
    if not result then return false end

    result = c.Best(c.WalkUpToCaveTransition, 10)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 4 }
    })

    result = c.Best(c.WalkUpToCaveTransition, 12)
    if result == 0 then return false end

    return true
end

local function _floor2()
    local result = c.WalkDown(5)
    if not result then return false end

    result = c.Best(c.WalkDownToCaveTransition, 10)
    if result == 0 then return false end

    result = c.WalkMap({
        { ['Down'] = 5 },
        { ['Left'] = 8 },
        { ['Up'] = 2 },
        { ['Left'] = 5 },
        { ['Down'] = 1 },
        { ['Left'] = 2 },
    })

    result = c.Best(c.WalkLeftToCaveTransition, 12)
    if result == 0 then return false end
    result = c.WalkLeft(4)

    result = c.Best(c.WalkLeftToCaveTransition, 12)
    if result == 0 then return false end

    return true
end

local function _floor3()
    local result = c.WalkRight(5)
    if not result then return false end
    esult = c.Best(c.WalkRightToCaveTransition, 12)
    if result == 0 then return false end
    result = c.WalkMap({
        { ['Right'] = 12 },
        { ['Down'] = 5 },
        { ['Right'] = 2 },
        { ['Down'] = 7 },
        { ['Left'] = 9 }
    })
    if not result then return false end
    c.BringUpMenu()
    result = c.Search()
    if not result then return false end
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    result = c.PushAWithCheck()
    if not result then return false end
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    local result = c.WalkUp(2)
    if not result then return false end
    c.BringUpMenu()
    result = c.Door()
    if not result then return false end
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Right'] = 4 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
    })
    c.PushDown()
    c.BringUpMenu()
    result = c.Door()
    if not result then return false end
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    result = c.WalkDown(3)
    if not result then return false end
    c.BringUpMenu()
    result = c.Search()
    if not result then return false end
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.BringUpMenu()
    c.HeroCastOutside()
    _tempSave(5)
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_floor1, 10)
    if c.Success(result) then
        local result = c.Best(_floor2, 10)
        if c.Success(result) then
            local result = c.Best(_floor3, 10)
            if c.Success(result) then
                local result = c.Best(_floor4, 10)
                if c.Success(result) then
                    c.Done()
                end
            end
        end
    end    
end

c.Finish()
