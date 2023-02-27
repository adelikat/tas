-- Starts at the first frame to end the dialog with the king
-- after the arena fight
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

local function _leaveChambers()
    c.RndAtLeastOne()
    c.PushFor('Down', 23)
    c.RndWalkingFor('Down', 8)
    c.PushFor('Right', 6)
    c.RndWalkingFor('Right', 24)
    c.PushFor('Down', 7)
    c.RndWalkingFor('Down', 16)
    _transition('Down')
    return true
end

local function _leaveCastle()
    c.PushFor('Down', 1)
    _transition('Down')
    return true
end

local function _leaveEndor()
    c.PushFor('Down', 1)
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushFor('Down', 8)
    c.RndWalkingFor('Down', 350)

    if c.Read(0x0045) ~= 33 then
        return c.Bail('Got blocked by NPC on way out')
    end

    _transition('Down')
    return true
end

local function _wingToSanteem()
    c.PushA() -- Bring up menu
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
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
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Alena
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Wing')
    end
    c.PushA() -- Pick Wing
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(7)
    c.UntilNextInputFrame()

    c.PushA() -- Santeem
    c.RandomFor(1)
    c.WaitFor(200)    
    c.UntilNextInputFrame()
    
    return true
end

local function _walkIntoSanteem()
    c.PushFor('Up', 16)
    c.RndWalkingFor('Up', 20)
    c.WaitFor(30)
    c.UntilNextInputFrame()

    return true
end

local function _walkUpStairs()
    c.PushFor('Up', 1)
    c.RndWalkingFor('Up', 210)
    c.WaitFor(30)
    c.UntilNextInputFrame()

    return true
end

local function _leaveSanteem()
    -- Standing still and walking one step are the same number of frames
    local flip = c.GenerateRndBool()
    flip = true
    if flip then
        local direction = c.GenerateRndDirection()
        c.Debug('Walking in direction: ' .. direction)
        c.PushFor(direction, 1)
        c.RndWalkingFor(direction, 16)        
    else
        c.WaitFor(17)
    end
    
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(6)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    
    c.PushA() -- Bring up menu
    c.WaitFor(17)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
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
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Alena
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Wing')
    end
    c.PushA() -- Pick Wing
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(7)
    c.UntilNextInputFrame()

    c.PushA() -- Santeem
    c.RandomFor(1)
    c.WaitFor(200)    
    c.UntilNextInputFrame()

    return true
end

local function _endChapter()
    c.RndAorB() -- the mysterious NEcrosaro
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB() -- and what befell the people of Santeem?
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne() -- Determined to solve these mysteries

    c.WaitFor(15)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAorB() -- The End of Chapter 2
    c.WaitFor(450)
    c.UntilNextInputFrame()

    c.RndAtLeastOne() -- Close End of Chapter 2 screen
    c.RandomFor(40) -- Magic Frame in here
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.PushA() -- Pick Yes to saving
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne() -- Chapter 3
    c.RandomFor(30) -- Magic Frame in here
    c.UntilNextInputFrame()

    c.RndAorB() -- This is lakanaba
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RndAorB() -- A man named Taloon
    c.WaitFor(70)    
    c.UntilNextInputFrame()

    c.RndAorB() -- He works for someone now

    c.WaitFor(70)    
    c.UntilNextInputFrame()

    c.Save(5)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Best(_leaveChambers, 14)
    result = c.Best(_leaveCastle, 14)
    result = c.Best(_leaveEndor, 14)
    result = c.Best(_wingToSanteem, 14)
    result = c.Best(_walkIntoSanteem, 14)
    result = c.Best(_walkUpStairs, 14)
    result = c.Best(_leaveSanteem, 50) -- Do more of this one
    result = c.Best(_endChapter, 50)
    c.Done()
end

c.Finish()
