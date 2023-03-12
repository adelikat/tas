-- Starts at the last lag frame entering Endor, with 7 Broad Swords and Shop Money
-- Gets the Shop, and Enters the King's chambers
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000
local stat = c.Addr.TaloonVit

local function _upUntilY(y, max)
    local result = c.RndUntilY('Up', y, max)
    if not result then
        return false
    end

    c.RandomFor(14)
    c.WaitFor(1)

    return true
end

local function _downUntilY(y, max)
    local result = c.RndUntilY('Down', y, max)
    if not result then
        return false
    end

    c.RandomFor(14)
    c.WaitFor(1)

    return true
end

local function _leftUntilX(x, max)
    local result = c.RndUntilX('Left', x, max)
    if not result then
        return false
    end

    c.RandomFor(14)
    c.WaitFor(1)

    return true
end

local function _rightUntilX(x, max)
    local result = c.RndUntilX('Right', x, max)
    if not result then
        return false
    end

    c.RandomFor(14)
    c.WaitFor(1)

    return true
end


local function _getShop()
	c.PushUp()
    local result = _upUntilY(21, 91)
    if not result then
        return false
    end
    c.PushLeft()
    result = _leftUntilX(4, 160)
    if not result then
        return false
    end
    c.PushDown()
    if c.Read(c.Addr.YSquare) ~= 22 then
        return c.Bail('NPC got in the way')
    end
    result = _downUntilY(23, 12)
    if not result then
        return false
    end
    c.PushLeft()
    if c.Read(c.Addr.XSquare) ~= 3 then
        return c.Bail('NPC got in the way')
    end
    c.RandomFor(14)
    c.WaitFor(1)
    c.PushDown()
    if c.Read(c.Addr.YSquare) ~= 24 then
        return c.Bail('NPC got in the way')
    end
    result = _downUntilY(29, 55)
    c.UntilNextInputFrame()
    c.PushRight()
    if c.Read(c.Addr.XSquare) ~= 2 then
        return c.Bail('Did nto go up stairs')
    end
    _rightUntilX(3, 16)
    c.PushUp()
    _upUntilY(4)
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Talk to Shopkeeper
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Yes to buying shop
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RandomFor(2) -- Input Frame
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()    

   
	return true
end

local function _enterCastle()
    c.RandomFor(2)
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() -- How wonderful! This is out shop
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() 
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB() 
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()

    c.PushA() -- queue up menu
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushLeft()

    if c.Read(c.Addr.XSquare) ~= 4 then
        return c.Bail('Unable to walk away from wife')
    end

    local result = _leftUntilX(3, 17)
    if not result then
        return false
    end

    c.PushUp()
    c.RndWalkingFor('Up', 90)
    c.PushFor('Right', 14)
    c.RndUntilY('Right', 7, 28)
    
    c.PushFor('Up', 4)
    result = _upUntilY(20, 20)
    if not result then
        return false
    end
    c.PushRight()
    result = c.RndUntilX('Right', 23, 120)
    if not result then
        return c.Bail('NPC got in the way')
    end

    c.PushFor('Up', 18)
    result = c.RndUntilY('Up', 10, 70)
    if not result then
        return c.Bail('NPC got in the way')
    end

    c.RandomFor(10)
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
    c.PushA()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.PushA()
    c.RandomFor(11)
    c.PushFor('Up', 25)
    c.UntilNextInputFrame()

    return true
end

local function _enterChambers()
    c.PushUp()
    c.RndWalkingFor('Up', 200)
    c.UntilNextInputFrame()
    c.Save(4)
    return true
end

local function _do()
    local result = c.Best(_getShop, 40)	
	if result > 0 then
        result = c.Best(_enterCastle, 40)
        if result > 0 then
            result = c.Best(_enterChambers, 50)
            if result > 0 then
                return true        
            end
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
    end
end

c.Finish()



