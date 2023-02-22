-- Walks on the overworld in a single direction
-- Ensures no encounters
-- Minimizes the number of step counter advances
-- In the given desired steps
-- Must start on the first frame the counter just advanced (or would have advanced)
local c = require("DW4-ManipCore")

c.InitSession()
c.reportFrequency = 2000

local direction = 'Left'
local desiredSteps = 3

---

local origBattleFlag = c.ReadBattle()
local idealSteps = 0
local bestSteps = 999

function _isEncounter()
	if origBattleFlag ~= c.ReadBattle() then
        return true
    end
    if c.ReadEGroup1Type() ~= 0xFF then
        return true
    end
end

local function _walk()
    local currStepCounter = c.ReadStepCounter()
    local frames = desiredSteps * 16
    c.Debug(string.format('Starting with %s steps', currStepCounter))

    for i = 0, frames, 1 do
        c.RndWalking(direction)
        if _isEncounter() then
            return c.Bail('Got encounter')
        end
        if c.ReadStepCounter() > bestSteps then
            return c.Bail('Too many steps')
        end
    end

    c.Debug('returning true')
    return true
end

c.Load(0)
c.Save(100)
while not c.done do
	c.Load(100)
    idealSteps = c.ReadStepCounter()
	local result = c.Cap(_walk, 100)

    if result then
        local steps = c.ReadStepCounter()
        c.LogProgress('Walked to destination, steps: ' .. steps)
        if steps == idealSteps then
            c.Done()
        elseif steps < bestSteps then
            c.Log('New best step counter: ' .. steps)
            c.Save('BestSteps-' .. steps)
            bestSteps = steps
        end	
    end

    c.Increment('Best step: ' .. bestSteps)
end

c.Finish()

