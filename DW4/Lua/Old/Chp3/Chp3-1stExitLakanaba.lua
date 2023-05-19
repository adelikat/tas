-- Starts at the beginning of chapter 3 after the first visible frame of moving down
-- After getting out of bed
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

_miss = 98
_hpAddr = c.Addr.AlenaHP
_bestDelay = 999

local function _transition(direction)
	local arrived = false

	-- we do not want to mistake a random lag frame for a transition, so we define it as 2 in a row
	local lastFrameWasLagged = false

	while not arrived do
		c.RndWalking(direction)
	
		if emu.islagged() then
			if lastFrameWasLagged then
				start = emu.framecount()
				c.Debug('Arrived at transition on frame ' .. start)
                c.WaitFor(20)
                c.UntilNextInputFrame()
				return true
			end

			lastFrameWasLagged = true
		else
			lastFrameWasLagged = false
		end
	end
end

local function _exitHome()
    c.RndWalkingFor('Down', 12)
    c.PushFor('Right', 4)
    c.RndWalkingFor('Right', 26)
    c.PushFor('Down', 2)
    c.RndWalkingFor('Down', 13)
    c.PushFor('Right', 3)
    c.RndWalkingFor('Right', 10)
    c.WaitFor(1)
    c.PushA() -- Bring up menu
    c.WaitFor(7)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Equip')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Door')
    end
    c.PushA() -- Pick Door
    c.WaitFor(8)
    c.UntilNextInputFrame()

    c.PushFor('Right', 16)
    _transition('Right')

    return true
end

local function _exitTown()
    c.PushUp()
    c.RndWalkingFor('Up', 13)
    c.WaitFor(1)
    c.PushFor('Left', 2)
    c.RndWalkingFor('Left', 300)
    c.PushFor('Up', 2)
    c.RndWalkingFor('Up', 102)
    c.PushFor('Left', 6)
    c.RndWalkingFor('Left', 30)
    c.PushFor('Up', 2)
    c.RndWalkingFor('Up', 92)
    c.PushFor('Left', 2)
    c.RndWalkingFor('Left', 76)

    if c.Read(0x0044) ~= 2 then
        return c.Bail('Blocked by NPC')
    end
    _transition('Left')
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Best(_exitHome, 10)
    if result > 0 then
        result = c.Best(_exitTown, 100)
        if result > 0 then
            c.Done()
        end
    end
end

c.Finish()
