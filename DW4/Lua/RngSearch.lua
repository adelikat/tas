
-- Runs through a scenario poking all RNG values to see if the situation is possible
-- The _do method should not have any random button presses or delays
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.PushA()
    c.WaitFor(65)
    
    -- if c.ReadTurn() ~= 1 then
    --     return c.Bail('Taloon did not go first')
    -- end

    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Gigademon did not attack')
    end
	-- c.Log(c.Read(c.Addr.E1Action2))
    -- if c.Read(c.Addr.E1Action2) ~=  66 then
    --     return true
    -- end



	-- local action2 = c.Read(c.Addr.E1Action2)
	-- if action2 ~= c.Actions.OnGuard and action2 ~= 247 then
    --     return c.Bail('Gigademon action 2 was not ideal')
    -- end

    --c.Log('Gigademon 2nd action was: ' .. c.Read(c.Addr.E1Action2))

    -- local taloonAction = c.Read(c.Addr.P2Action)
    -- if taloonAction == 247 then
    --     c.Log('Taloon did not make up his mind yet')
    --     return false
    -- end

    -- c.Debug('Taloon: ' .. c.TaloonActions[taloonAction])
    -- if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
    --     return c.Bail('Taloon did not call for reinforcements')
    -- end


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
	--local result = c.FrameSearch(_do, 1000)	
	if c.Success(result) then
		c.Log('Attempts: ' .. c.attempts)
		c.Done()
	else
		c.Log('Nothing found')
	end

	--c.Log('Total Best Damage: ' .. bestDamage)
	c.Done()
end

c.Finish()



