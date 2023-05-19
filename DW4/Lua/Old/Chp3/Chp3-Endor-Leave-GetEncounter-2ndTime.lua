-- Starts at the last lag frame entering the king's chamber
-- Talks to king, drops off 7 broad swords,
-- Wings out of town and gets an encounter on the first square
-- Gets the Shop, and Enters the King's chambers
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local origBattleFlag

local function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
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

local function _walkToKingAndGoDownStairs()
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

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushDown()

    local y = 14
    if c.GenerateRndBool() then
        y = 15
    end

    c.RndUntilY('Down', y)
    c.RandomFor(14)
    c.PushRight()
    c.PushRight()
    c.RndWalkingFor('Right', 29)
    c.WaitFor(1)
    c.PushDown()
    c.RndWalkingFor('Down', 100)
    c.UntilNextInputFrame()

	return true
end

local function _swordDropOffAndLeave()
    c.PushDown()
    c.RndUntilY('Down', 28)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 2)
    local result = c.RndUntilX('Right', 16, 30)
    if not result then
        return c.Bail('NPC got in the way')
    end
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Up', 2)

    local result = c.RndUntilY('Up', 23, 60)
    if not result then
        return c.Bail('NPC got in the way')
    end    

    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Right', 2)
    if c.Read(c.Addr.XSquare) ~= 17 then
        return c.Bail('NPC got in the way')
    end

    local result = c.RndUntilX('Right', 18, 17)
    if not result then
        return c.Bail('NPC got in the way')
    end
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Up', 2)
    if c.Read(c.Addr.YSquare) ~= 22 then
        return c.Bail('NPC got in the way')
    end
    c.RandomFor(12)
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
    c.RandomFor(12)
    c.PushFor('Up', 4)
    c.RndWalkingFor('Up', 20)
    c.RandomFor(6)
    c.PushFor('Left', 2)
    c.RandomFor(12)
    c.WaitFor(1)
    c.PushFor('Up', 2)

    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    c.PushA() -- Talk
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2) -- Input frame
    c.UntilNextInputFrame()
    c.PushA() -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.RndAorB()
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
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.PushA() -- Bring up menu
    c.UntilNextMenuY()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.UseFirstMenuItem()

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
    c.RandomFor(1)
    c.WaitFor(200)
    c.UntilNextInputFrame()

    return true
end

local function _encounter()
    origBattleFlag = c.ReadBattle()
    c.PushA()
    c.RandomFor(14)
    c.PushRight()
    c.RandomFor(17)

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

    c.UntilNextInputFrame()
    c.Log('------')
    c.Log('Encounter Found!')
    c.Save(string.format('aaaEncounter-%s-%s-%s', emu.framecount(), c.ReadEGroup1Type(), c.ReadRng2()))
    return false
end

local function _do()
    local result = c.Best(_walkToKingAndGoDownStairs, 3)
    if result > 0 then
        result = c.Best(_swordDropOffAndLeave, 3)
        if result > 0 then
            return c.Cap(_encounter, 75)
        end
    end
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
	local result = _do()
    if result then
        c.Done()
    else
        c.Log('RNG: ' .. c.RngCacheLength())
    end
end

c.Finish()



