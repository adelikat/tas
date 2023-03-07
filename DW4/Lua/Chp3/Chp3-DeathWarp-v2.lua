-- Starts on the first visible frame of walking up towards the treasure chest
-- Manipulates an encounter with a single enemy, and a self-critical hit
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local origBattleFlag = c.ReadBattle()
local function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
end


local function _walkToChest()    
    local arrived = false
    while true do
		c.RndWalking('Up')
		if _isEncounter() then
			c.Debug('Encounter')
			return false
		end
		
		local y = c.Read(c.Addr.YSquare)
        if y == 4 then
            return true
        end
	end	
end

local function _pickUpChest()
    c.PushA()
    c.UntilNextMenuY()
    c.WaitFor(3)
    c.UntilNextInputFrame()

    if _isEncounter() then
        return c.Bail('Got enounter on treasure chest')
    end

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Failed to navigate to Status')
    end
    c.PushRight()
    if c.ReadMenuPosY() ~= 33 then
        return c.Bail('Failed to navigate to Item')
    end
    c.PushDown()
    if c.ReadMenuPosY() ~= 34 then
        return c.Bail('Failed to navigate to Tactics')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 35 then
        return c.Bail('Failed to navigate to Tactics')
    end
    c.PushA()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.RndAorB()
    c.WaitFor(30)
    c.UntilNextInputFrame()

    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()


    return true
end

local function _getEncounter()
    local direction = c.GenerateRndDirection()
    c.PushFor(direction, 18)
    c.RndWalkingFor(direction, 16)
    if not _isEncounter() then
        return c.Bail('Failed to get encounter')
    end

    c.UntilNextInputFrame()
    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Got 2 enemy groups')
    end

    -- if c.ReadE1Count() ~= 1 then
    --     return c.Bail('Did not get 1 enemy')
    -- end

    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Cap(_walkToChest, 1000)
    if result then
        result = c.Cap(_pickUpChest, 20)
        if result then
            result = c.Cap(_getEncounter, 1000)
            if result then
                c.Done()
            else
                c.Log('Could not get encoutner')
            end
            
        end
    else
        c.Log('Could not walk to chest')
    end
	
end

c.Finish()
