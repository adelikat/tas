-- Starts at the magic frame before the fight
-- Manipulates Taloon going first, summoning reinforcements, and defeating one of the Anderougs
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
    c.RandomFor(2)
    c.WaitFor(13)
    c.RndAtLeastOne()
    c.WaitFor(7)
    c.RndAtLeastOne()
    c.WaitFor(7)
    c.RndAtLeastOne()
    c.RandomFor(27)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(70)
    c.WaitFor(22)
    if c.ReadTurn() >= 4 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
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
    local dmgNeeded = 60
    c.RndAtLeastOne()
    c.WaitFor(59)
    c.RndAtLeastOne()
    c.WaitFor(17)
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
    local eActionAddr = c.Addr.E2Action
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

    _tempSave(0)
    local result = c.ProgressiveSearch(__miss, 100, 17)
    if not result then
        return false
    end


    return true
end

c.Load(7)
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
    --             c.Done()
    --         end
    --     end
    -- end

    local result = c.Cap(_miss, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
