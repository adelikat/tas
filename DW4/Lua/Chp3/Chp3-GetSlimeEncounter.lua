--Starts at the last lag frame after exiting lakanaba for the first time
--Will manipulate a slime encounter within the first few steps and ensure
--That there are no skips in the step counter
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 10000

local origBattleFlag = c.ReadBattle()

local function _isEncounter()
	local battle = c.ReadBattle()
	return battle ~= origBattleFlag
end

local function _isSingleSlime()
    if c.ReadEGroup1Type() ~= 0 then
        return c.Bail('Did not encounter slime')
    end

    if c.ReadEGroup2Type() ~= 0xFF then
        return c.Bail('Encountered a 2nd group')
    end

    if c.ReadE1Count() ~= 1 then
        return c.Bail('More than 1 slime')
    end

    if c.ReadE1Hp > 6 then
        return c.Bail('Too much HP')
    end

    return true
end

local function _walkOneSquare(expectedStepCounter)
    c.RndWalkingFor('Right', 16)
    
    if not _isEncounter() and c.ReadStepCounter() ~= expectedStepCounter then
        return c.Bail('Step counter did not tick')
    end

    return true
end

local function _walkRight()
    c.PushRight()
    if c.ReadStepCounter() ~= 41 then
        return c.Bail('Step counter did not tick on first step')
    end

    -- Hacky, we can continue even if success since we know we aren't walking n early as many frames as the encounter animation
    local result = false
    for i = 42, 53, 1 do
        result = _walkOneSquare(i)
        if not result then
            return false
        end
    end

    if _isEncounter() then
        c.UntilNextInputFrame()
        if _isSingleSlime() then
            return true
        else
            c.Log('Encounter')
        end        
    end
  
    return false
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
	local result = c.Cap(_walkRight, 20)
	if result then
        c.Done()
    end	
end

c.Finish()



