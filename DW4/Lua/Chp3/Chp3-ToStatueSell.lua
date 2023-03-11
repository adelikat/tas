-- Starts at the first visible frame of moving up towoards the door in Endor
-- That leads to the person that we sell the statue to
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local direction = 'Up'

local function _isLag()
	return emu.islagged()
end

local function _saveBest(frameCount)
	c.Save(9)
	c.Save('Transition' .. frameCount)
end

local function _walkToTransition()
    arrived = false

	-- we do not want to mistake a random lag frame for a transition, so we define it as 2 in a row
	lastFrameWasLagged = false

	while not arrived do
		c.RndWalking(direction)
		
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

local function _openDoor()
    c.RndUntilY('Up', 16)
    c.WaitFor(1)
    c.PushA()
    c.UntilNextMenuY()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to equip')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to door')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.RndWalkingFor('Up', 10)
    c.PushFor('Up', 7)
    c.RndWalkingFor('Up', 17)
    c.UntilNextInputFrame()

    return true
end

local function _upStairs()
    c.PushUp()
    c.RndWalkingFor('Left', 11)
    c.PushFor('Left', 6)
    c.RndUntilX('Left', 2)
    c.RndWalkingFor('Left', 10)
    c.PushFor('Up', 7)
    c.RndWalkingFor('Up', 16)
    c.UntilNextInputFrame()

    c.Log('Saving 6')
    c.Save(6)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_openDoor, 10)        
	if result > 0 then
        result = c.Best(_upStairs, 10)
        if result > 0 then
            c.Done()
        else
          c.Log('Unable to go up stairs')
        end
	end
end

c.Finish()



