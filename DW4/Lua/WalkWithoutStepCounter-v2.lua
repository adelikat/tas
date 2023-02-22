-- Walks on the overworld in a single direction for two squares
-- Ensures no encounters
-- Is considered a success if one of those squares does not advance counter
-- Must start on the first frame the counter just advanced (or would have advanced)
-- Will stop after 1 square if the first square is manipulated
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 20000

local direction = 'Left'
local direction2 = 'Down'
---

local origBattleFlag = c.ReadBattle()

function _isEncounter()
	if origBattleFlag ~= c.ReadBattle() then
        return true
    end
    if c.ReadEGroup1Type() ~= 0xFF then
        return true
    end
end

local function _walkOneSquare()    
    c.RndWalkingFor(direction, 16)    
    if _isEncounter() then
        return c.Bail('Got encounter')
    end

    return true
end

local function _tryOneSquare()
    local currStepCounter = c.ReadStepCounter()

    local noEncounters = c.Cap(_walkOneSquare, 100)
    if noEnounters == false then
        c.Log('Could not avoid encounter, this should never happen!')
        return false
    end

    if c.ReadStepCounter() > currStepCounter then
        return c.Bail('Advanced step counter')
    end
end

local function _tryOneSquare2()
    local currStepCounter = c.ReadStepCounter()

    local noEncounters = c.Cap(_walkOneSquare, 100)
    if noEnounters == false then
        c.Log('Could not avoid encounter, this should never happen!')
        return false
    end

    if c.ReadStepCounter() > currStepCounter then
        return c.Bail('Advanced step counter')
    end
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
    local square1 = c.Cap(_tryOneSquare, 500)
    
    if square1 then
        c.Done()
    else
        c.Log('Square 1 failed. Trying next square')
        c.Cap(_walkOneSquare, 100)
        c.Save(5)

        local square2 = c.Cap(_tryOneSquare, 500)
        if square2 then
            c.Done()
        end
    end
    
    c.Log('Unable to manip square')
end

c.Finish()

