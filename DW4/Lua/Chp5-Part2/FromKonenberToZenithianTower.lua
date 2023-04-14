-- Starts at the last lag frame upon arrving at Konenber from Stancia
-- Manipulates taking the baloon to Gottside Island and entering the zenithian tower
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _toIsland()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.ChargeUpWalking()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 2 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if not c.WalkLeft(29) then return false end

    local direction = 'Left'
    if c.GenerateRndBool() then
        direction = 'Down'
    end

    if not c.Walk(direction) then return false end
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _toTower()
    c.ChargeUpWalking()
    local result = c.WalkMap({
        { ['Right'] = 3 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 9 },
        { ['Down'] = 8 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    -- Poison Swamp
    c.WaitFor(5)
    if not c.WalkLeft() then return false end
    c.WaitFor(5)
    if not c.WalkDown() then return false end
    c.WaitFor(5)
    if not c.WalkLeft() then return false end
    c.WaitFor(5)
    if not c.WalkDown() then return false end
    c.WaitFor(5)
    if not c.WalkDown() then return false end
    c.WaitFor(5)
    if not c.WalkLeft() then return false end
    c.WaitFor(5)
    if not c.WalkLeft() then return false end
    c.WaitFor(5)
    if not c.WalkDown() then return false end
    c.WaitFor(5)
    if not c.WalkDown() then return false end
    c.WaitFor(5)
    if not c.WalkDown() then return false end
    c.WaitFor(5)
    result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_toIsland, 25)
    if c.Success(result) then
        local result = c.Best(_toTower, 100)
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

    local result = c.Best(_do, 10)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()

