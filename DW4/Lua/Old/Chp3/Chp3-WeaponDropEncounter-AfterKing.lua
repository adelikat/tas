-- Starts at the first visible frame of moving up towoards the door in Endor
-- That leads to the person that we sell the statue to
-- Manipulates the walk to the king and an ideal enemy encounter after one square of walking
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local origBattleFlag
local function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
end

local function _openDoor()
    c.PushDown()
    c.RndWalkingFor('Down', 13)
    c.WaitFor(1)
    c.PushFor('Left', 3)
    c.RndUntilX('Left', 37)
    c.RndWalkingFor('Up', 12)
    c.WaitFor(1)
    c.PushUp()
    c.RndUntilY('Up', 13)
    c.RndWalkingFor('Up', 12)
    c.WaitFor(1)
    c.PushFor('Left', 3)
    c.RndUntilX('Left', 24, 350)
    c.RndWalkingFor('Left', 12)
    c.WaitFor(1)
    c.PushFor('Up', 2)
    c.RndUntilY('Up', 10)
    c.WaitFor(1)
    c.PushA()
    c.RandomFor(10)
    c.UntilNextMenuY()
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
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.RandomFor(10)
    c.PushFor('Up', 6)
    c.RndWalkingFor('Up', 16)

    c.UntilNextInputFrame()

    return true
end

local function _enterKingsChambers()
    c.PushLeft()
    c.RndWalkingFor('Left', 13)
    c.WaitFor(1)
    c.PushFor('Up', 3)
    c.RndWalkingFor('Up', 170)
    c.UntilNextInputFrame()
    return true
end

local function _path1()
    c.PushUp()
    c.RndUntilY('Up', 12)
    c.RndWalkingFor('Left', 13)
    c.WaitFor(1)
    c.PushLeft()
    c.RndUntilX('Left', 11)
    c.RndWalkingFor('Left', 13)
    c.WaitFor(1)
    c.PushUp()
    c.RandomFor(14)
    c.WaitFor(1)    
    return true
end

local function _path2()
    c.PushLeft()
    c.RndWalkingFor('Left', 13)
    c.WaitFor(1)
    c.PushFor('Up', 1)
    c.RndUntilY('Up', 14)
    c.RndWalkingFor('Left', 12)
    c.WaitFor(1)
    c.PushLeft()
    c.RndWalkingFor('Left', 13)
    c.WaitFor(1)
    c.PushUp()
    c.RndUntilY('Up', 11)
    c.RandomFor(14)
    c.WaitFor(1)
    return true
end

local function _walkToKing()
    local result
    local flip = c.GenerateRndBool()
    if flip then
        result = _path1()
    else
        result = _path2()
    end

    if not result then
        return false
    end

    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(4)
    c.UntilNextInputFrame()
    c.PushA() -- Talk
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne() -- Close dialog
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then 
        return c.Bail('Unable to navigate to status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Unable to navigate to item')
    end

    c.PushA() -- Pick Item
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Pick Taloon
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushDown()    
    if c.ReadMenuPosY() ~= 17 then 
        return c.Bail('Unable to navigate to broad sword')
    end
    c.WaitFor(1)

    c.PushDown()    
    if c.ReadMenuPosY() ~= 18 then 
        return c.Bail('Unable to navigate to broad sword')
    end
    c.WaitFor(1)

    c.PushDown()    
    if c.ReadMenuPosY() ~= 19 then 
        return c.Bail('Unable to navigate to broad sword')
    end
    c.WaitFor(1)
    c.PushDown()    
    if c.ReadMenuPosY() ~= 20 then 
        return c.Bail('Unable to navigate to wing')
    end
    c.PushA() -- Pick wing
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushA() -- Use
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then 
        return c.Bail('Unable to navigate to Bonmalmo')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then 
        return c.Bail('Unable to navigate to Endor')
    end

    c.PushA()
    c.RandomFor(2)
    c.UntilNextInputFrame()
  
    return true
end

local function _encounter()
    origBattleFlag = c.ReadBattle()
    c.RandomFor(12)
    c.PushFor('Right', 4)
    local direction = c.GenerateRndDirection()
    c.RndWalkingFor(direction, 19)

    c.AddToRngCache()
    if not _isEncounter() then
        return c.Bail('Did not get encounter')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        c.Log('Got 2nd enemy group')
        return c.Bail('Got a 2nd enemy group')
    end

    if c.ReadE1Count() ~= 1 then
        c.Log('Did not get 1 enemy')
        return c.Bail('Did not get 1 enemy')
    end

    if c.ReadEGroup1Type() == 0xAD then
        c.Log('Got Merchant')
        return c.Bail('Got Merchant')
    end

    return true
end

local function _chambers()
    local result =  c.Cap(_walkToKing, 4)
    if result then
        return c.Cap(_encounter, 100)
    end
end

local function _do()
    local result = c.Best(_openDoor, 5)
    if result > 0 then
        result = c.Best(_enterKingsChambers, 5)
        if result > 0 then
            return c.Cap(_chambers, 10)
        end        
    end    
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    result = _do()
    c.Log('RNG: ' .. c.RngCacheLength())
    if result then
        c.Done()
    end
end

c.Finish()



