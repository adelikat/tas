-- Starts on the first visible frame of walking up after
-- The dogs runs toward the fox
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0

_miss = 98
_hpAddr = c.Addr.AlenaHP
_bestDelay = 999

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

    c.UseFirstMenuItem()

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

-- Note that these methods leave a lot of RNG manip on the table because of all the frames during the push methods
-- that could be random buttons, but RNG2 does not change in this town and we have a lot of squares to work with
-- so it is expected that enough RNG seeds can be generated
local function _night()
    _rndUntilY('Up', 11)
    _pushUntilX('Right', 21)
    _rndUntilX('Right', 24)
    _pushUntilY('Up', 10)
    _rndUntilY('Up', 2)
    _pushUntilX('Left', 23)
    _rndUntilX('Left', 13)
    _pushUntilY('Down', 3)
    _pushUntilX('Left', 12)
    c.WaitFor(1)
    c.PushA()
    c.PushFor('Up', 15)
    c.UntilNextMenuY()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    return true
end

local function _morning()
    c.PushA()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RndAorB() -- No! Help!
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    c.RandomFor(1) -- Magic frame
    c.WaitFor(10)
    c.UntilNextInputFrame()
    
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- Thanks! Here, let me give you this armor
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- Taloon obtains the Full Plate Armor
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()

    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.RandomFor(230)
    c.UntilNextInputFrame()

    c.RndAorB() -- What happened?
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- When I woke up, the village was gone
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- That's right
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.RandomFor(70)
    c.WaitFor(1)
    c.PushFor('A', 33)
    c.UntilNextInputFrame()

    _useFirstMenuItem()

    -- Pick Bonmalmo
    c.PushDown()
    c.PushA()

    c.WaitFor(100)
    c.UntilNextInputFrame()

    return true
end

local function _enterBonmalmo()
    c.PushFor('Up', 20)
    c.RandomFor(20)
    c.UntilNextInputFrame()
    return true
end

local function _exitTown()
    c.Best(_night, 15)
    c.Best(_morning, 30)
    c.Best(_enterBonmalmo, 15)    
    return true
end


c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = c.Best(_exitTown, 0)
    if result > 0 then        
        c.Done()
    end
end

c.Finish()
