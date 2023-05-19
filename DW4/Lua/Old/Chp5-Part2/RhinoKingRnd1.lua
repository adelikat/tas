-- Starts at the magic frame before the RhinoKing + Bengal fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(1)
    c.WaitFor(14)

    c.RndAtLeastOne()
    c.WaitFor(7)
    
    c.RndAtLeastOne()
    c.RandomFor(26)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)

    --------------------
    if c.ReadTurn() ~= 4 then
        return c.Bail('Rhinoking did not go first')
    end

    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Rhinoking did not attack')
    end

    if c.Read(c.Addr.E1Target) ~= 0 then
        return c.Bail('Rhinoking did not target Hero')
    end

    if c.ReadBattleOrder1() < c.ReadBattleOrder5() then
        return c.Bail('Hero went before Rhinoking')
    end

	if c.ReadBattleOrder6() < c.ReadBattleOrder2() then
        return c.Bail('Bengal went before Taloon')
    end

    if c.Read(0x7334) ~= 247 then
        return c.Bail('Rhinoking had a 2nd action')
    end

    --------------------

    c.UntilNextInputFrame()
    c.WaitFor(2)
    _tempSave(4)
    return true
end

local function _rhinoKingDmg()
	c.RndAtLeastOne()
	c.WaitFor(5)

    local hp = c.Read(c.Addr.HeroHP) == 0
    if hp == 0 then
        c.UntilNextInputFrame()
        c.WaitFor(2)
        return true
    end

    return false
end

local function _taloonCritical()
    c.RndAtLeastOne()
    c.WaitFor(21)
    c.RndAtLeastOne()
    c.RandomFor(30)
    c.WaitFor(5)

    if c.Read(c.Addr.P2Action) ~= 67 then
        return c.Bail('Taloon did not attack')
    end    

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(5)

    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 100 then
        return c.Bail('Taloon did not do enough damage')
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
	-- local result = c.Cap(_turn, 100)
	-- if c.Success(result) then
    --     c.Log('Turn Manipulated')
    --     result = c.Cap(_rhinoKingDmg, 8)
    --     if c.Success(result) then
	-- 	    c.Done()
    --     end
	-- end

    local result = c.Cap(_taloonCritical, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()



