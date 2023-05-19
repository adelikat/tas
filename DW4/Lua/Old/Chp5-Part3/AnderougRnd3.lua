-- Starts at the first frame to dimiss the last dialog of round 2
-- Manipulates Taloon going first, summon reinforcements, and defeating the last Anderoug
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 0
delay = 0

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(37)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(50)
    if c.ReadTurn() >= 4 then
        return c.Bail('Taloon did not go first')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction == 247 then
        --c.WaitFor(10)
        --taloonAction = c.Read(c.Addr.P2Action)
        --if taloonAction == 247 then
            c.Log('Taloon did not make up his mind yet')
        --end        
    end

    -- if taloonAction ~= 67 then
    --     c.Log(c.TaloonActions[taloonAction])
    -- end

    if taloonAction ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _taloonCritical()
    c.RndAtLeastOne()
    c.WaitFor(87)
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
    c.DelayUpTo(1)
    local dmgNeeded = 63
    c.RndAtLeastOne()
    c.WaitFor(19)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DelayUpTo(1)
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
    --     local result = c.ProgressiveSearch(_taloonCritical, 100, 5)
    --     if c.Success(result) then
    --         local result = c.ProgressiveSearch(_taloonRegular, 100, 1)
    --         if c.Success(result) then
                c.Done()
    --         end
    --     end
    -- end
    local result = c.Cap(_taloonRegular, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
