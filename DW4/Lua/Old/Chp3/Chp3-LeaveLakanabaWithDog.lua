-- Starts in Lakanaba after giving the Wing to the prisoner
-- Starts at the first visible frame of walking down after passing the inn
-- X: 7, Y 14, this is important so that the NPC has already been maniuplated to not be in the way
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

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

-- Starts at the first frame that the command menu is useable
local function _useFirstMenuItem()
    c.PushDown()
    
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end
    c.PushA()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Pick first character
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Pick first item
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA() -- Use
    c.WaitFor(2)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    -- Taloon is already walking down
    c.RndWalkingFor('Down', 41)
    c.PushFor('Right', 5)
    _rndUntilX('Right', 21)
    -- The path here is intentional to decrease the chance of the boy NPC of getting in the way
    c.PushFor('Up', 16)

    if not _atPosition(21, 15) then
        return c.Bail('NPC got in the way')
    end

    c.RndWalkingFor('Up', 24)
    c.PushFor('Right', 3)
    c.RndWalkingFor('Right', 26)

    if not _atPosition(23, 14) then
        return c.Bail('NPC got in the way')
    end

    c.PushFor('Up', 5)
    c.RndWalkingFor('Up', 26)
    c.PushFor('Left', 6)

    if not _atPosition(22, 12) then
        return c.Bail('NPC got in the way')
    end

    c.RndWalkingFor('Left', 8)
    c.PushFor('Up', 5)
    c.RndWalkingFor('Up', 26)

    c.PushFor('Right', 4)
    c.RndWalkingFor('Right', 23)
    c.WaitFor(1)
    c.PushA()
    c.PushFor('Up', 4)
    c.WaitFor(1)    

    if not emu.islagged() then
        return c.Bail('Lag at Door')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Failed to navigate to Equip')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Failed to navigate to Door')
    end
    c.PushA()
    c.WaitFor(3)    
    c.UntilNextInputFrame()

    _pushUntilY('Up', 9)
    _rndUntilY('Up', 6)
    c.RndWalkingFor('Up', 10)
    c.PushFor('Left', 6)
    c.RndWalkingFor('Left', 10)
    c.PushFor('Up', 5)
    _rndUntilY('Up', 4)
    c.RndWalkingFor('Up', 6)
    c.WaitFor(1)
    c.PushA()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Lagged at menu')
    end

    c.PushA()

    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB() -- Taloon! It's me, Tom's son
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- Yes, I'll reward you
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RndAorB() -- What? you just want to borrow my dog
    c.WaitFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.RandomFor(65) -- Can pres random characters while dog is walking towards you, without costing time
    c.UntilNextInputFrame()

    c.RndAorB() -- Bow, Wow, Wow! <3
    c.WaitFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushA() -- Open Menu
    c.UntilNextMenuY()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    local result = _useFirstMenuItem()
    if not result then
        return false
    end
    
    -- Pick Bonmalmo
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Bonmalmo')
    end
    c.PushA()

    c.WaitFor(100)
    c.UntilNextInputFrame()

    c.Log('Saving 4')
    c.Save(4)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 100)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
