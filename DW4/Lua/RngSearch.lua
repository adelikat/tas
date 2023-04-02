
-- Runs through a scenario poking all RNG values to see if the situation is possible
-- The _do method should not have any random button presses or delays
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.PushA()
    c.WaitFor(27)
    c.UntilNextInputFrame()
    c.WaitFor(3)
    if not c.PushAWithCheck() then return false end -- Fight
    c.WaitFor(8)
    c.WaitFor(6)
    if not c.PushAWithCheck() then return false end -- Attack
    c.WaitFor(4)
    delay = c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end -- Keeleon
    c.WaitFor(20)
    c.WaitFor(20)

    --c.AddToRngCache()

    ---------------------------------

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    if c.ReadBattleOrder1() > c.ReadBattleOrder5() then
        return c.Bail('Hero did not go 2nd')
    end

    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
	local result = c.RngSearch(_turn)	
	if c.Success(result) then
		c.Done()
	else
		c.Log('Nothing found')
	end
end

c.Finish()



