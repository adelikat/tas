direction = 'Up'
cap = 120
best = 999999999

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local origBattleFlag = c.ReadBattle()

function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
end

function _isLag()
	return emu.islagged()
end

function _saveBest(frameCount)
	c.Save(9)
	c.Save('Transition' .. frameCount)
end

function _walkToTransition()
	c.Save(11)
	arrived = false

	-- we do not want to mistake a random lag frame for a transition, so we define it as 2 in a row
	lastFrameWasLagged = false

	while not arrived do
		c.RndWalking(direction)

		if _isEncounter() then
			c.Load(11)
		end

		if emu.islagged() then
			if lastFrameWasLagged then
				c.Debug('Arrived at transition on frame ' .. emu.framecount())
				return -- Success! We are at the transition
			end

			lastFrameWasLagged = true
		else
			lastFrameWasLagged = false
		end

	end	
end

while not c.done do
	client.displaymessages(false)
	c.Load(0) 
	_walkToTransition()	
	c.WaitFor(30) -- An optimization, we know a screen transition is never this fast
	c.UntilNextInputFrame()

	frames = emu.framecount()
		if (frames < best) then
			best = frames
			c.Log("best so far: " .. frames .. " attempt " .. c.attempts)
			_saveBest(frames)
		end

	c.Increment()
	if (c.attempts > cap) then
		c.Abort()
	end
end
client.displaymessages(false)
c.Finish()


