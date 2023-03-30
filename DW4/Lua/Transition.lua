local direction = 'Up'
local cap = 50
local best = 999999999

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local start = 0
local totalTransFrames = 0

local function _isEncounter()
	return false
	--return c.ReadEGroup1Type() ~= 0xFF or c.ReadEGroup2Type() ~= 0xFF
end

local function _isLag()
	return emu.islagged()
end

local function _saveBest(frameCount)
	c.Save(9)
	c.Save('Transition' .. frameCount)
end

local function _walkToTransition()
	c.Save(11)
	arrived = false

	-- we do not want to mistake a random lag frame for a transition, so we define it as 2 in a row
	lastFrameWasLagged = false

	while not arrived do
		c.RndWalking(direction)

		if _isEncounter() then
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

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100) 
	_walkToTransition()
	c.AddToRngCache()
	c.WaitFor(30) -- An optimization, we know a screen transition is never this fast
	c.UntilNextInputFrame()

	frames = emu.framecount()
	totalTransFrames = frames - start
	if (frames < best) then
		best = frames
		c.Log(string.format("best so far: %s attempt %s total transition frames: %s", frames, c.attempts, totalTransFrames))
		_saveBest(frames)
	end

	
	c.Increment()
	if (c.attempts > cap) then
		c.Abort()
	end
end
c.Log(string.format('RNG: %s', c.RngCacheLength()))
c.Log(string.format('Best Transition frames: %s', totalTransFrames))
c.Finish()
c.Load(9)
