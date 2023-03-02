-- Starts on the last lag frame after entering Endor for the first time
-- Maniuplates entering the castle and then kings chambers
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

local function _enterCastle()
    c.PushUp()
    local result = _rndUntilY('Up', 10, 600)
    if not result then
        return c.Bail('NPC got in the way')
    end
    c.RndWalkingFor('Up', 2)
    c.WaitFor(1)

    c.PushA() -- Bring up menu
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
    c.PushA() -- Pick Door
    c.WaitFor(10)
    c.UntilNextInputFrame()

    _pushUntilY('Up', 9)
    c.RndWalkingFor('Up', 20)
    c.UntilNextInputFrame()

    return true
end

local function _enterChambers()
    _pushUntilY('Up', 33)
    _transition('Up')
    return true
end

local function _do()
    local result = _enterCastle()
    if result then
        result = _enterChambers()
        if result then
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
    local result = c.Best(_do, 500)
    --result = c.Best(_enterChambers, 10)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
