-- Starts at the last lag frame after entering gardenbur
-- Manipuklates entering the castle, going to jail with Ragnar left in jail, and exiting
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

-- We can't press A or we queue it up for the jail cell
-- so we need a special randomness
-- We could be more random by pressing a random direction every frame, but we do not need that much RNG variance, this is more than enough
local function _randomFor(frames)
    local direction = c.GenerateRndDirection()
    c.RndWalkingFor(direction, frames)
end

local function _walk(direction)
    c.PushFor(direction, 1)
    c.RndWalkingFor(direction, 15)
end

-- Ran this manually
local function _enterCastle()
    local result = c.WalkUp(13)
    if not result then return false end
    c.BringUpMenu()
    c.Door()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.WalkUp()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _toThiefRoom()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 2 },
        { ['Up'] = 2 },
        { ['Right'] = 3 },
        { ['Up'] = 3 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.RandomFor(2)
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)

    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Up'] = 3 },
        { ['Left'] = 2 },
        { ['Up'] = 5 },
        { ['Right'] = 3 },
        { ['Up'] = 5 },
        { ['Left'] = 2 }
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _toQueen()
    local result = c.WalkLeft(3)
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    -- Random isn't good here because we can't press A or we queue it up for the jail cell
    -- Could be more random by not pressing up, but we don't need that much RNG
    _randomFor(10) 
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    _randomFor(140)
    c.PushFor('Right', 4)
    _randomFor(50)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()    
    _randomFor(70)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    _randomFor(70)
    c.UntilNextInputFrame()
    _randomFor(360)
    c.UntilNextInputFrame()
    _randomFor(100)
    c.UntilNextInputFrame()
    _randomFor(368)

    _walk('Left')
    _walk('Up')
    _walk('Right')
    _walk('Right')
    _walk('Down')
    _walk('Left')
    _walk('Left')
    _walk('Up')
    _walk('Right')
    _walk('Right')
    _walk('Down')
    _walk('Left')
    _walk('Up')
    c.WaitFor(50)
    _randomFor(180)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _backToJail()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushB() -- No
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    return true
end

local function _upStairs()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(45)
    c.PushA()
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Up'] = 2}
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _leave()
    local result = c.WalkRight(6)
    if not result then return false end
    result = c.WalkRightToCaveTransition()
    if not result then return false end
    result = c.WalkMap({
        { ['Right'] = 4 },
        { ['Up'] = 3 }
    })
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_toThiefRoom, 10)
	if c.Success(result) then
        local result = c.Best(_toQueen, 10)
        if c.Success(result) then
            local result = c.Best(_backToJail, 10)
            if c.Success(result) then
                local result = c.Best(_upStairs, 10)
                if c.Success(result) then
                    local result = c.Best(_leave, 10)
                    if c.Success(result) then
                        return true
                    end
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
	local result = c.Best(_do, 5)
	if c.Success(result) then
		c.Done()
	end
end

c.Finish()



