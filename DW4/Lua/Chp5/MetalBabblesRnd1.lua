
-- Starts at the magic frame before the fight with 2 metal babbles
-- Manipulates one of them running away, and killing the other, with a critical
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 2000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(27)
    c.WaitFor(4)
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lagged at picking Fight')
        return false
    end
    c.WaitFor(10)
    c.RandomFor(5)
    c.WaitFor(4)
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lagged at picking Attack')
        return false
    end

    c.WaitFor(4)
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lagged at picking Metal Babble')
        return false
    end

    c.RandomFor(30)

    ----------------------
    -- Note: It doesn't seem possible for Hector (or hero) to get initiative

    local e1Action = c.Read(c.Addr.E1Action)
    local e2Action = c.Read(c.Addr.E2Action)
    local e1Initiative = c.ReadBattleOrder5()
    local e2Initiative = c.ReadBattleOrder6()
    local actionsPassed = false
    -- 88 = run away
    if (e1Action == 88 and e1Initiative == 0 and e2Action == 67) then
        actionsPassed = true
    end

    if (e1Action == 67 and e2Initiative == 0 and e2Action == 88) then
        actionsPassed = true
    end

    if not actionsPassed then
        return c.Bail('Metal babbles did not behave')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _babbleMiss()
    -- Because Nara and Mara are dead, we know Hector cannot be targeted, only the hero (due to a bug in the game)
    local origHp = c.Read(c.Addr.HeroHP)
    c.RndAtLeastOne()
    c.RandomFor(25)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(5)

    local currHp = c.Read(c.Addr.HeroHP)
    local dmg = origHp - currHp
    c.Debug('dmg: ' .. dmg)

    c.AddToRngCache()
    c.Debug('RNG: ' .. c.RngCacheLength())

    if dmg > 0 then
        return c.Bail('Did not miss')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

-- If hector gets initiative
local function _hectorCritical()
    c.RndAtLeastOne()
    c.RandomFor(30)
    if c.Read(c.Addr.P4Action) == 62 then
        return c.Bail('Hector built power')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(5)
    local dmg = c.ReadDmg()
    c.Debug('Dmg: ' .. dmg)
    if dmg < 10 then
        return c.Bail('Did not get critical')
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
--client.unpause()
client.speedmode(3200)
while not c.done do
	c.Load(100)
    local result = c.ProgressiveSearch(_hectorCritical, 50, 10)
    if result then
        c.Done()
    end
	-- local result = c.Cap(_turn, 100)
    -- if c.Success(result) then
    --     c.Log('Turn manipulated')
    --     result = c.Cap(_babbleMiss, 50)
    --     if result then
    --         c.Done()
    --     else
    --         c.Log('Unable to get miss RNG: ' .. c.RngCacheLength())
    --     end
    -- end
end

c.Finish()



