-- Starts at the magic frame before the Gigademon fight
-- Manipulates Taloon going first and Tripping Gigademon,
-- Notes: Gigademon's Round 2 is scripted for him to be on guard
-- Once on guard, there's no way to do enough damage even when building power,
-- There is also no way to defeated him in round 1
-- So we have no choice but to get through round 1 as quickly as possible, build power on round 2, to defeated him in round 3
-- The fastest way to get through round one is for Taloon to go first, trip Gigademon, so that he only has the one action of tripping, instead of 2 attacks
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.WaitFor(12)
    c.RndAtLeastOne()
    c.RandomFor(23)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(32)
    c.WaitFor(15)

    c.AddToRngCache()
    ----------------------------------------------

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Gigademon did not attack')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction == 247 then
        c.Log('Taloon did not make up his mind yet')
        return false
    end

    c.Debug('Taloon: ' .. c.TaloonActions[taloonAction])
    if c.Read(c.Addr.P2Action) ~= c.Actions.SweepsLegs then
        return c.Bail('Taloon did not call for reinforcements')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

-- sweeps legs, gigdademon trips, writhing
local function _finishRound()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

c.Load(2)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)
    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        local result = c.Best(_finishRound, 25)
        if c.Success(result) then
            c.Done()
        end
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

