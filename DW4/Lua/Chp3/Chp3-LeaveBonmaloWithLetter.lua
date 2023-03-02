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
    c.PushUp()
    c.RndWalkingFor('Up', 59)
    c.PushFor('Right', 4)
    c.RndWalkingFor('Right', 12)
    c.PushFor('Up', 5)
    c.RndWalkingFor('Up', 38)
    c.PushFor('Right', 6)
    _rndUntilX('Right',  28)
    c.RndWalkingFor('Right', 13)
    c.WaitFor(1)
    c.PushFor('Up', 3)
    _rndUntilY('Up', 16)
    c.RndWalkingFor('Up', 12)
    c.WaitFor(1)
    c.PushFor('Right', 5)
    _rndUntilX('Right',  32)
    c.RndWalkingFor('Right', 12)
    c.WaitFor(1)
    c.PushFor('Up', 3)
    _rndUntilY('Up', 7)
    c.RndWalkingFor('Up', 6)
    c.WaitFor(1)
    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Talk
    c.WaitFor(50)
    c.UntilNextInputFrame()
    c.RndAorB() -- Oh, here you are! It's me, Prince Reed
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- I'd like you to go to Endor as soon as the bridge is repaired
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- And hand this letter to the princess of Endor
    c.WaitFor(100)
    c.UntilNextInputFrame()

    c.RndAorB() -- I'm counting on you
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne() -- Closing dialog
    c.WaitFor(2)
    c.UntilNextInputFrame()
    
    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.WaitFor(4)
    c.UntilNextInputFrame()

    local result = _useFirstMenuItem()
    if not result then
        return false
    end
    
    -- Pick Lakanaba
    c.PushA()

    c.WaitFor(100)
    c.UntilNextInputFrame()

    c.Log('Saving 5')
    c.Save(5)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Best(_do, 5)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
