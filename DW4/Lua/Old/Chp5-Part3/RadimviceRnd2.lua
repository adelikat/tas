-- Starts at the first frame to dismiss the last dialog of round 1
-- Manipulates
-- Hero and Taloon both boing before Radimvice
-- Hero attacking himself and scoring a critical hit to die
-- Taloon calling for reinforcements and defeating Radimvice
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 3
delay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(40)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(9)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(4)
    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(3)
    c.DelayUpToWithLAndR(10)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(40)

    if c.ReadTurn() ~= 0 then
        return c.Bail('Hero did not go first')
    end

    if c.ReadBattleOrder5() < c.ReadBattleOrder2() then
        return c.Bail('Radimvice got initiative over Taloon')
    end
    
    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _heroCrit()    
    c.RndAtLeastOne()
    c.WaitFor(6)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 92 then
        return false
    end

    return true
end

-- Starts from the first frame to dismiss the "Terrific Blow" from the hero's self crit
local function _taloonReinforcements()
    c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(22)

    c.RndAtLeastOne()
    c.RandomFor(30)
    c.WaitFor(5)

    c.AddToRngCache()
    local taloonAction = c.Read(c.Addr.P2Action)
    c.Debug('taloon: ' .. c.TaloonActions[taloonAction])
    if taloonAction ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
    -- local result = c.Cap(_turn, 250)
    -- if c.Success(result) then
    --     c.Log('Turn Manipulated')
    --     local result = c.ProgressiveSearch(_heroCrit, 200, 3)
    --     if c.Success(result) then
    --         c.Done()
    --     else
    --         c.Log('Failed to find critical')
    --     end
    -- end

    local result = c.Cap(_taloonReinforcements, 250)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
