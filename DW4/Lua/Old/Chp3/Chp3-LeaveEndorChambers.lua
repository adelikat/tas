-- Starts on the last lag frame after entering the King's Chambers in Endor for the first time
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

local function _pushUntilX(direction, x, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        c.PushFor(direction, 1)
        if c.Read(c.Addr.XSquare) == x then
            return true
        end
    end

    return false
end

local function _pushUntilY(direction, y, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        c.PushFor(direction, 1)
        if c.Read(c.Addr.YSquare) == y then
            return true
        end
    end

    return false
end

local function _rndUntilY(direction, y, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        c.PushFor(direction, 1)
        if c.Read(c.Addr.YSquare) == y then
            return true
        end
    end

    return false
end

local function _rndUntilX(direction, x, max)
    if not max then
        max = 1000 -- avoid a potentially infinite loop
    end

    for i = 0, max, 1 do
        c.RndWalkingFor(direction, 1)
        if c.Read(c.Addr.XSquare) == x then
            return true
        end
    end

    return false
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

local function _leaveEndor()
    _pushUntilY('Up', 18)
    _rndUntilY('Up', 12)
    _pushUntilX('Right', 14)
    _rndUntilX('Right', 15)
    _pushUntilY('Up', 11)
    c.WaitFor(1)
    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(8)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Status')
    end
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
        return c.Bail('Unable to navigate to Wing')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Wing')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Unable to navigate to Prince Letter')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA()
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.RndAorB() -- Taloon reads the Prince's Letter
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.RndAorB() -- Dear Mia
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.RndAorB() 
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(130)
    c.UntilNextInputFrame()

    c.RndAorB()  -- King heard the news
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.RndAorB() -- You do not need to worry
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.RndAorB() -- Taloon is the name
    c.WaitFor(20)    
    c.UntilNextInputFrame()

    c.RndAorB() -- Taloon receives the Royal scroll
    c.WaitFor(10)    
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(3)
    c.UntilNextInputFrame()    
    c.PushFor('A', 128)
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        c.Bail('Unable to navigate to item')
    end
    c.PushA()

    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Wing
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    c.PushA()
    c.WaitFor(100)
    c.UntilNextInputFrame()

    return true
end

local function _enterBonmalmo()
    c.PushFor('Up', 20)
    c.RndWalkingFor('Up', 20)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    local result = c.Best(_leaveEndor, 20)
    if result > 0 then
        result = c.Best(_enterBonmalmo, 30)
        if result > 0 then
            return true
        end
    end

    return false
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 4)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
