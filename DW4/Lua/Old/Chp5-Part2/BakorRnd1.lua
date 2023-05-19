-- Starts at the magic frame before the Bakor fight
-- Manipulates round 1
-- Notes:
-- Taloon crit range: 115-132 (double when power built)
-- Hero crit range: 78-90
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 3
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(25)
    c.WaitFor(3)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.WaitFor(3)
    c.UntilNextInputFrame()
    
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()

    c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(5)

    c.AddToRngCache()

    ------------------
    if c.Read(c.Addr.E1Action) ~= 10 then
        c.Log('Jackpot!!! Bakor did not cast snowstorm')
        c.Save('Bakor-Rnd1-Action-Jackpot')
        return true
    end

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction ~= c.Actions.Attack then
        c.Debug('Taloon Action: ')
    end
    
    if taloonAction ~= c.Actions.BuildingPower then
        return c.Bail('Taloon did not build power')
    end
    --- 

    c.UntilNextInputFrame()
    c.WaitFor(2)

    -- c.Save('BakorTemp')
    
    -- local origHeroHp = c.Read(c.Addr.HeroHP)
    -- c.RndAtLeastOne()
    -- c.WaitFor(5)

    -- local currHeroHp = c.Read(c.Addr.HeroHP)
    -- if origHeroHp ~= currHeroHp then
    --     return c.Bail('Taloon did not block the spell')
    -- end

    -- c.Load('BakorTemp')

    return true
end

-- Assumes Bakor went 2nd
local function _bakorSpellBlocked()
    -- Important to not put delay frames here or snowstorm will not be stopped
    c.RndAtLeastOne()
    c.RandomFor(30)
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)    

    c.AddToRngCache()
    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
        return c.Bail('Taloon did not build power')
    end

    c.Save('BakorTemp')
    local origHeroHp = c.Read(c.Addr.HeroHP)

    c.RndAtLeastOne()
    c.WaitFor(8)

    local currHeroHp = c.Read(c.Addr.HeroHP)
    if origHeroHp ~= currHeroHp then
        return c.Bail('Taloon did not block the spell')
    end

    c.Load('BakorTemp')

    return true
end

-- Assumes hero went 3rd, and Bakor went 2nd and had spell blocked by taloon
local function _heroCritical()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.WaitFor(5)

    delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.WaitFor(10)

    c.AddToRngCache()

    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg > 20 then
        c.Log('Critical: ' .. dmg)
    end

    if dmg < 87 then
        return c.Bail('not enough damage')
    end

    c.Log('delay: ' .. delay)
    return true
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
	--local result = c.Cap(_turn, 100)
    local result = c.Cap(_heroCritical, 100)
	if c.Success(result) then
        c.Done()
	end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()



