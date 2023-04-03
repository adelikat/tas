
-- Runs through a scenario poking all RNG values to see if the situation is possible
-- The _do method should not have any random button presses or delays
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.WaitFor(2)
    c.WaitFor(13)
    c.PushA()
    c.WaitFor(25)
    c.WaitFor(4)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(4)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to spell')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to parry')
    end
    --c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end 
    c.WaitFor(43)

    --c.AddToRngCache()
    -------------------------------
    local balzackAction = c.Read(c.Addr.E1Action)
    if balzackAction ~= 67 then
        return c.Bail('Balzack did not attack')
    end

    local balzackTarget = c.Read(c.Addr.E1Target)
    if balzackTarget ~= 2 then
        return c.Bail('Balzack did not target Ragnar')
    end

    -- if c.ReadTurn() ~= 0 then
    --     return c.Bail('Hero did not go first')
    -- end

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
        return c.Bail('Taloon did not build power')
    end

    --Seems to be the 2nd action of Balzack, possibly other bosses
    if c.Read(0x7334) ~= 67 then
        return c.Bail('Balzack 2nd action was not an attack')
    end
    -------------------------------
    
    c.Log('Candidate found')
    c.Save(string.format('BalzackRnd1-Candidate-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
    return false
end


c.Load(0)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_do)	
	if c.Success(result) then
		c.Log('Attempts: ' .. c.attempts)
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



