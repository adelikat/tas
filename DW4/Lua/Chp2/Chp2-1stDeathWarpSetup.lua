-- Starts at the first visible frame of walking left, on the first square available
-- to begin walking left to the treasure and manipulates
-- an encounter on the first possible step with a
-- single group of Ozwargs
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 5
local origBattleFlag = c.ReadBattle()

function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
end

local function _walkToTreasure()
    local arrived = false
    for i = 0, 40 do
        c.RndWalking('Left')
        if _isEncounter() then
			return c.Bail('Encounter')
		end
    end

    c.WaitFor(1)
    return true
end

local function _pickUpTreasure()
    c.PushA()
    c.WaitFor(16)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Lag at Status')
    end

    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Lag at Item')
    end

    c.PushDown()
    if c.ReadMenuPosY() ~= 34 then
        return c.Bail('Lag at Tactics')
    end

    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 35 then
        return c.Bail('Lag at Search')
    end

    c.PushA() -- Search
    c.WaitFor(40)
    c.UntilNextInputFrame()

    c.RndAorB() -- Alena opens the treasure chest
    c.WaitFor(38)
    c.UntilNextInputFrame()

    c.RndAorB() -- 
    c.WaitFor(200)    
    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _getEncounter()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    local direction = c.GenerateRndDirection()
    c.PushFor(direction, 17)
    c.RndWalkingFor(direction, 14)
    c.WaitFor(5)
    if _isEncounter() ~= true then
        return c.Bail('Did not get an encounter')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Multiple groups')
    end

    if c.ReadEGroup1Type() ~= 29 then
        return c.Bail('Did not get an Ozwarg')
    end

    c.WaitFor(100)
    c.UntilNextInputFrame()
    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Cap(_walkToTreasure, 20)
    if result then
        c.Debug('Walked to Treasure')
        result = c.Cap(_pickUpTreasure, 10)
        if result then
            result = c.Cap(_getEncounter, 500)
            if result then
                c.Done()
            else
                c.Log('Unable to get encounter')
            end
        else
            c.Log('Unable to pickup trasure')
        end
    else
        c.Log('Unable to walk to treasure')        
    end
    
	c.Increment()
end

c.Finish()

