-- Starts on the last lag frame after Bonmalmo after receiving the letter from the king of endor
-- Maniuplates the conversation and winging out
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100

local function _atPosition(x, y)
    if c.Read(c.Addr.XSquare) ~= x then
        return false
    end

    if c.Read(c.Addr.YSquare) ~= y then
        return false
    end

    return true
end

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

local function _do()
    c.PushUntilY('Up', 30)
    c.RndUntilY('Up', 8)
    c.WaitFor(1)
    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Status')
    end
    c.WaitFor(1)
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to Item')
    end
    c.PushA() -- Pick Item
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Pick Taloon
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to wing')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Full Plate')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Royal Scroll')
    end
    c.PushA() -- Pick Royal Scroll
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(10)
    c.UntilNextInputFrame()

    for i = 0, 6, 1 do
        c.RndAorB()
        c.WaitFor(10)
        c.UntilNextInputFrame()
    end

    c.RndAtLeastOne()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.UseFirstMenuItem()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Bonmalmo')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Failed to navigate to Endor')
    end
    c.PushA()
    c.WaitFor(100)
    c.UntilNextInputFrame()

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 50)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
