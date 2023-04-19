-- Starts at the magic frame before the fight
-- Manipulates
-- Hero getting initiative over all 3 Demighouls and casting expel
-- Radimvice only getting 1 attack
-- Taloon building power
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 5000
c.maxDelay = 10

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.WaitFor(12)
    c.RndAtLeastOne()
    c.WaitFor(7)
    c.RndAtLeastOne()
    c.RandomFor(30)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end -- Fight
    c.RandomFor(10)
    c.WaitFor(5)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Spell')
    end
    if not c.PushAWithCheck() then return false end -- Spell
    c.WaitFor(6)
    if not c.PushAWithCheck() then return false end -- Expel
    c.WaitFor(6)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Demighoul')
    end
    delay = c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(35)

    c.AddToRngCache()
    ---------------------------------------
    -- Battle Order
    -- 1 = Hero
    -- 2 = Taloon
    -- 4 = Radimvice
    -- 5 = Demi 1
    -- 6 = Demi 2
    -- 7 = Demi 3

    local d1o = c.ReadBattleOrder4()
    if d1o ~= 1 and d1o ~= 0 then
        c.Log('Demi 1 got something greater than a 1: ' .. d1o)
    end
    if c.ReadTurn() == 0 then
		return true
	end
    
    if c.ReadTurn() == 1 then
        if c.ReadBattleOrder1() == 1 then
            return true
        end
    end

    if c.ReadTurn() == 4 then
        local radimviceAction = c.Read(c.Addr.E1Action)
        
        if radimviceAction == 15 or radimviceAction == 12
            or (radimviceAction == 1 and c.Read(c.Addr.E1Target) == 0)
        then
            return c.Bail('Radimvice must cast Infermost or Blizzard, or target Hero with Blazemore in order for Taloon to cover mouth')
        end

        local heroInit = c.ReadBattleOrder1()
        
        if heroInit == 1 then
            return true
        end

        local demi1Init = c.ReadBattleOrder5()
        local demi2Init = c.ReadBattleOrder6()
        local demi3Init = c.ReadBattleOrder7()

        if heroInit < demi1Init and heroInit < demi2Init and heroInit < demi3Init
        then
            return true
        end

        if demi1Init ~= 1 then
            c.Save(string.format('RadimviceRnd1-H-%s-D1-%s-D2-%s-D3-%s', heroInit, demi1Init, demi2Init, demi3Init))
            c.Log(string.format('Demi 1 was not fast H: %s, d1: %s, d2: %s, d3: %s', heroInit, demi1Init, demi2Init, demi3Init))
        end
    end

    ---------------------------------------
    return false
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
    local result = c.Cap(_turn, 250)
    if c.Success(result) then
        c.Log('delay: ' .. delay)
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
