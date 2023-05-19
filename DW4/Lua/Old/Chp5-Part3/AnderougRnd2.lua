-- Starts at the first frame to dimiss the last dialog of round 1
-- Manipulates Taloon going first, summon reinforcements, and defeating one of the Anderougs
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(37)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(67)
    if c.ReadTurn() >= 4 then
        return c.Bail('Taloon did not go first')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    
    if taloonAction == 247 then
        c.WaitFor(10)
        taloonAction = c.Read(c.Addr.P2Action)
        if taloonAction == 247 then
            c.Log('Taloon did not make up his mind yet')
        end        
    end

    if taloonAction ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    if taloonAction ~= 67 then
        c.Log(c.TaloonActions[taloonAction])
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _taloonCritical()
    c.RndAtLeastOne()
    c.WaitFor(86)
    c.RndAtLeastOne()
    c.WaitFor(17)
    c.RndAtLeastOne()
    c.WaitFor(6)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 240 then
        return c.Bail('Did not do enough dmg')
    end
    return true
end

local function _taloonRegular()
    local dmgNeeded = 60
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(5)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < dmgNeeded then
        return c.Bail('Did not do enough damage')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function __miss()
    local origHp = c.Read(c.Addr.TaloonHp)
    c.RndAtLeastOne()
    c.WaitFor(6)
    local currHp = c.Read(c.Addr.TaloonHp)
    if currHp < origHp then
        return c.Bail('Got hit: ' .. c.ReadDmg())
    end    

    return true
end

local function _miss()
    local eActionAddr = c.Addr.E3Action
    c.RndAtLeastOne()
    c.WaitFor(15)
    c.RndAtLeastOne()
    c.WaitFor(17)
    c.RndAtLeastOne()
    c.WaitFor(46)
    c.RndAtLeastOne()
    c.RandomFor(47)
    c.UntilNextInputFrame()

    local action = c.Read(eActionAddr)
    c.Debug('action: ' .. action)
    if c.Read(eActionAddr) ~= 67 then
        return c.Bail('Enemy did not attack')
    end

    c.WaitFor(2)
    local rngResult = c.AddToRngCache()
    if not rngResult then
        c.Log('RNG already found')
        return false
    end

    _tempSave(7)
    local result = c.ProgressiveSearch(__miss, 100, 15)
    if not result then
        return false
    end


    return true
end

c.Load(6)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
    -- local result = c.Cap(_turn, 100)
    -- if c.Success(result) then
    --     c.Log('Turn manipulated')
    --     local cacheResult = c.AddToRngCache()
    --     if cacheResult then
    --         _tempSave(4)
    --         local result = c.ProgressiveSearch(_taloonCritical, 150, 10)
    --         if c.Success(result) then
    --             --local result = c.ProgressiveSearch(_taloonRegular, 100, 1)
    --             --if c.Success(result) then
    --                 c.Done()
    --             --end
    --         else
    --             c.Log('Failed to find critical')
    --         end
    --     else
    --         c.Log('RNG already found')
    --     end
    -- end

    --local result = c.Cap(_taloonRegular, 100)
    local result = c.Cap(_miss, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
