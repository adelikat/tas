-- Starts at the last lag frame upon leaving Endor with 60k gold
-- Spends 60k at the cave and re-enters endor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _isEncounter()
	local eg1Type = c.ReadEGroup1Type()
	return eg1Type ~= 0xFF
end

local function _walkToTransition(direction)
    local failAttempt = 0
	c.Save(11)
	arrived = false

	-- we do not want to mistake a random lag frame for a transition, so we define it as 2 in a row
	lastFrameWasLagged = false

	while not arrived do
		c.RndWalking(direction)

		if _isEncounter() then
            failAttempt = failAttempt + 1
            if failAttempt > 50 then
                return false
            end
			c.Debug('Encounter')
			c.Load(11)
		end
		
		if emu.islagged() then
			if lastFrameWasLagged then
				start = emu.framecount()
				c.Debug('Arrived at transition on frame ' .. start)
				return -- Success! We are at the transition
			end

			lastFrameWasLagged = true
		else
			lastFrameWasLagged = false
		end

	end	
end

local function _enterCave()
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushFor('Right', 2)
    c.RndWalkingFor('Right', 42)
    if _isEncounter() then
        return c.Bail('Encounter')
    end
    c.WaitFor(1)
    c.PushFor('Up', 3)

    c.RndWalkingFor('Up', 42)
    if _isEncounter() then
        return c.Bail('Encounter')
    end

    c.PushFor('Right', 5)
    if _isEncounter() then
        return c.Bail('Encounter')
    end

    c.RndWalkingFor('Right', 155)
    if _isEncounter() then
        return c.Bail('Encounter')
    end

    c.PushFor('Up', 4)
    if _isEncounter() then
        return c.Bail('Encounter')
    end

    c.RndWalkingFor('Up', 85)
    if _isEncounter() then
        return c.Bail('Encounter')
    end

    c.PushFor('Right', 7)
    if _isEncounter() then
        return c.Bail('Encounter')
    end

    _walkToTransition('Right')
    c.UntilNextInputFrame()

    return true
end

local function _leaveCave()
    c.PushUp()
    c.RndUntilY('Up', 9)
    c.RandomFor(12)
    c.WaitFor(1)
    
    c.PushFor('Right', 3)
    c.RndUntilX('Right', 16)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Down', 3)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 3)
    c.RandomFor(9)
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Talk
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomFor(11)
    c.WaitFor(1)

    c.PushFor('Up', 4)

    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Left', 4)

    c.RndUntilX('Left', 5)

    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Down', 4)

    _walkToTransition('Down')
    c.UntilNextInputFrame()

    return true
end

local function _reenterCave()
    local direction = 'Left'
    local reverseDirection = 'Right'
    if c.GenerateRndBool() then
        direction = 'Down'
        reverseDirection = 'Up'
    end

    c.PushFor(direction, 1)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor(reverseDirection, 4)
    if _isEncounter() then
        return c.Bail('Got encounter')
    end

    c.RandomFor(20)
    c.UntilNextInputFrame()

    return true
end

local function _reexitCave()
    c.PushUp()
    c.RndUntilY('Up', 9)
    c.RandomFor(12)
    c.WaitFor(1)
    
    c.PushFor('Right', 3)
    c.RndUntilX('Right', 16)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Down', 3)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 3)
    c.RandomFor(9)
    c.UntilNextMenuY()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Talk
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomFor(11)
    c.WaitFor(1)

    c.PushFor('Up', 4)

    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Left', 4)

    c.RndUntilX('Left', 5)

    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Down', 4)

    _walkToTransition('Down')
    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    local result = c.Best(_enterCave, 19)
    if result > 0 then
        result = c.Best(_leaveCave, 7)
        if result > 0 then
            result = c.Best(_reenterCave, 49)
            if result > 0 then
                result = c.Best(_reexitCave, 7)
                if result > 0 then
                    c.Done()
                end                
            end
        end
    end
end

c.Finish()



