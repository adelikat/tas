--Starts at the first visible frame of walking down after the conversation with brey
local c = require("DW4-ManipCore")
c.InitSession()
c.maxDelay = 0
c.reportFrequency = 100

local function _bail(msg)
	c.Debug(msg)
	c.Increment()
	return false
end

local function _untilMenuOpen()
    c.Save('MenuTemp')

    while c.ReadMenuPosY() ~= 16 do
        c.Save('MenuTemp')
        c.WaitFor(1)
    end

    c.Load('MenuTemp')
end

local function _fromBreyToDownStairs()
    c.RndWalkingFor('Down', 47)
    c.WaitFor(21)
    c.UntilNextInputFrame()
    return true    
end

function _walkToTransition(direction)
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
				c.Debug('Arrived at transition on frame ' .. emu.framecount())
				return -- Success! We are at the transition
			end

			lastFrameWasLagged = true
		else
			lastFrameWasLagged = false
		end

	end	
end

local function _transition(direction)
    _walkToTransition(direction)
    c.WaitFor(30) -- An optimization, we know a screen transition is never this fast
	c.UntilNextInputFrame()
end

local function _transitionUp()
    _transition('Up')
end

local function _transitionRight()
    _transition('Right')
end

local function _transitionLeft()
    _transition('Left')
end

local function _talkToGuardAndCristoAndGoBackUpStairs()
    c.PushFor('Left', 3)
    c.PushFor('Down', 15)
    c.RndWalkingFor('Down', 147)
    c.WaitFor(1)
    c.PushA()
    _untilMenuOpen()

    c.WaitFor(7)
    c.PushA()

    c.WaitFor(3)
    if c.ReadMenuPosY() ~= 31 then
        return _bail('Lag talking to guard')
    end

    c.WaitFor(50)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne() -- Close conversation with guard
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushFor('Up', 20)
    c.RndWalkingFor('Up', 130)
    c.PushFor('Right', 12)
    c.RndWalkingFor('Right', 24)
    c.WaitFor(1)
    c.PushFor('Up', 10)
    c.PushFor('Right', 12)

    c.RndWalkingFor('Right', 163)
    c.PushFor('Up', 12)
    c.RndWalkingFor('Up', 72)
    c.PushA() -- Start convo with cristo
    c.PushFor('Left', 6)
    _untilMenuOpen()
    c.WaitFor(7)
    c.PushA()
    c.WaitFor(3)
    if c.ReadMenuPosY() ~= 31 then
        return _bail('Lag talking to Cristo')
    end

    c.WaitFor(80)
    c.UntilNextInputFrame()
    c.RndAorB() -- Brey told me your plan to go out alone
    c.WaitFor(25)
    c.UntilNextInputFrame()
    c.RndAorB() -- That's so reckless

    c.WaitFor(98)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAorB() -- I mean the King will be devastated
    c.WaitFor(5)
    c.PushFor('Down', 25)
    c.RndWalkingFor('Down', 30)
    c.WaitFor(14)
    c.UntilNextInputFrame()
    c.PushFor('Down', 26)
    c.PushFor('Left', 8)
    c.RndWalkingFor('Left', 193)
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _fromKingChambersToUpstairs()
    c.PushFor('Up', 3)
    c.RndWalkingFor('Up', 130)
    c.PushFor('Right', 15)
    c.RndWalkingFor('Right', 66)
    c.PushA()
    c.WaitFor(6)
    _untilMenuOpen()
    c.WaitFor(7)
    c.PushDown() -- To Status
    if c.ReadMenuPosY() ~= 17 then
        return _bail('Lag navigating to Status menu')
    end    
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return _bail('Lag navigating to Equip menu')
    end    
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return _bail('Lag navigating to Door menu')
    end
    c.PushA() --Open Door
    c.WaitFor(8)
    c.UntilNextInputFrame()    
    c.PushFor('Right', 8)
    c.RndWalkingFor('Right', 93)
    c.PushFor('Up', 10)

    c.Best(_transitionUp, 8)

    return true
end

local function _escapeChambers()
    c.PushFor('Left', 3)
    c.RndWalkingFor('Left', 86)
    c.PushFor('Up', 7)
    c.RndWalkingFor('Up', 20)
    c.WaitFor(1)
    c.PushA() -- Open menu to open door
    c.WaitFor(10)
    _untilMenuOpen()
    c.WaitFor(7)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return _bail('Lag navigating to Status menu')
    end    
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return _bail('Lag navigating to Equip menu')
    end    
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return _bail('Lag navigating to Door menu')
    end
    c.PushA() --Open Door
    c.WaitFor(8)
    c.UntilNextInputFrame()    
    c.PushFor('Up', 20)
    c.RndWalkingFor('Up', 16)
    c.PushFor('Right', 14)
    c.PushFor('Up', 17)
    c.RndWalkingFor('Up', 16)
    c.PushFor('Right', 17)
    c.PushA() -- Open menu to search wall
    c.WaitFor(10)
    _untilMenuOpen()
    c.WaitFor(7)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return _bail('Lag navigating to Status menu')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return _bail('Lag navigating to Item menu')
    end
    c.PushDown()
    if c.ReadMenuPosY() ~= 34 then
        return _bail('Lag navigating to Tactics menu')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 35 then
        return _bail('Lag navigating to Search menu')
    end
    c.PushA() -- Pick Search
    c.WaitFor(43)
    c.UntilNextInputFrame()
    c.RndAorB() -- Alena inspects the wall
    c.WaitFor(72)
    c.UntilNextInputFrame()
    c.RndAorB() -- Flimsy boards
    c.WaitFor(30)
    _untilMenuOpen()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(160)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(8)
    c.UntilNextInputFrame()
    c.PushFor('Right', 20)
    c.Best(_transitionRight, 8)
    return true
end

local function _dropFromRoof()
    c.PushFor('Up', 12)
    c.PushFor('Left', 20)
    c.Best(_transitionLeft, 8)
    return true
end

local function _walkOutOfCastle()
    c.PushFor('Up', 20)
    c.Best(_transitionUp, 8)
    return true
end

local function _fullLoop()
    c.Best(_fromBreyToDownStairs, 8)
    c.Best(_talkToGuardAndCristoAndGoBackUpStairs, 8)
    c.Best(_fromKingChambersToUpstairs, 1)
    c.Best(_escapeChambers, 1)
    c.Best(_dropFromRoof, 0)
    c.Best(_walkOutOfCastle, 0)
    console.log('Loop result: ' .. emu.framecount())
    c.Log('Loop result: ' .. emu.framecount())
    c.Save('CastleLoop' .. emu.framecount())
    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
    c.Best(_fullLoop, 20)

    c.Save(4)
    c.Done()
end

c.Finish()
