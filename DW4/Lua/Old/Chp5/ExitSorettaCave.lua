-- Starts at the last lag frame after entering the cave South of Soretta
-- Manipulates getting the seed and casting outside
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _floor1()
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 1 },
        { ['Left'] = 7 },
        { ['Down'] = 3 },
    })
    if not result then return false end
    c.PushDown()
    c.RandomFor(39)
    local result = c.WalkMap({
        { ['Down'] = 2 },
        { ['Left'] = 3 },
        { ['Down'] = 1 },
        { ['Left'] = 3 },
        { ['Down'] = 4 },
        { ['Left'] = 8 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
   return true
end

local function _floor2()
    local result = c.WalkMap({
        { ['Left'] = 4 },
        { ['Up'] = 3 },
    })
    if not result then return false end
    c.RandomFor(32)
    local result = c.WalkMap({
        { ['Up'] = 6 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.RandomFor(424)
    local result = c.WalkMap({
        { ['Right'] = 5 },
        { ['Down'] = 6 },
    })
    if not result then return false end
    c.RandomFor(72)
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 9 },
        { ['Down'] = 4 },
        { ['Right'] = 4 },
        { ['Down'] = 3 },
        { ['Left'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Right'] = 2 },
    })
    if not result then return false end
    c.RandomFor(72)
    result = c.WalkUp(4)
    if not result then return false end
    c.RandomFor(88)
    local result = c.WalkMap({
        { ['Left'] = 5 },
        { ['Down'] = 1 },
    })
    if not result then return false end
    c.RandomFor(48)
    local result = c.WalkMap({
        { ['Down'] = 2 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.RandomFor(64)
    c.BringUpMenu()
    c.Search()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.BringUpMenu()
    c.HeroCastOutside()
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.Best(_floor1, 20)	
    if c.Success(result) then
        result = c.Best(_floor2, 20)
        if c.Success(result) then
            result = c.Best(_floor3, 20)
            if c.Success(result) then
                c.Done()
            end
        end
    end
end

c.Finish()

