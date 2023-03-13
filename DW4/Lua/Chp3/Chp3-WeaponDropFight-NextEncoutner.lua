-- Starts at the first frame to navigate past the message
-- 'x has a treasure chest'
-- Manipulates an encounter within 2 steps
-- If a direction is specified, will use that
-- else will pick a random direction left or right
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local desiredDirection = nil --'Left'
local origBattleFlag

local function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
end

local function _finishFight()
    c.DelayUpToForLevels(4)
    c.RndAorB() 
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.DelayUpToForLevels(4)
    c.RndAorB() -- Taloon opens the treasure chest
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.DelayUpToForLevels(4)
    c.RndAorB() -- Finds the x
    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(20)
    c.UntilNextInputFrame()

    return true
end

local function _getEncounter()
    origBattleFlag = c.ReadBattle()
    local direction = desiredDirection
    if desiredDirection == nil then
        local flip = c.GenerateRndBool()
        if flip then
            direction = 'Left'
        else
            direction = 'Right'
        end
    end
    c.PushFor(direction, 1)
    c.RndWalkingFor(direction, 34)

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
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    local result = c.Cap(_finishFight, 100)        
	if result then
        result = c.Cap(_getEncounter, 300)
        if result then
            c.Done()
        else
            c.Log('RNG count: ' .. c.RngCacheLength())
        end
	end
end

c.Finish()



