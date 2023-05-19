-- Starts at the magic frame before an encounter with a single chaos hopper after the gas cansister
-- Manipulates getting confused and getting a self-critical
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
    c.RandomFor(25)
    c.WaitFor(3)
    if not c.PushAWithCheck() then
        c.Log('Could not advance Fight menu')
        return false
    end
    c.RandomFor(27)
    c.WaitFor(20)
    if c.ReadTurn() ~= 4 then
        return c.Bail('Chaos Hopper did not go first')
    end

    if c.Read(c.Addr.E1Action) ~= 27 then
        return c.Bail('Chaos Hopper did not cast chaos')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    
    return true
end

local function _chaos()
    c.RndAtLeastOne()
    c.WaitFor(5)

    -- This is Taloon's status, it seems
    if c.Read(0x721F) ~= 4 then
        return c.Bail('Taloon did not get confused')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

local function _selfCritical()
    c.RndAtLeastOne()
    c.RandomFor(27)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(33)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Taloon is confused
    if c.Read(c.Addr.P2Action) ~= 67 then
        return c.Bail('Taloon did not attack')
    end

    c.WaitFor(1)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(6)

    c.AddToRngCache()
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg > 120 then
        c.Log('Critical! ' .. dmg)
        _tempSave(5)
    end
    if c.Read(c.Addr.TaloonHp) > 0 then
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
    --     result = c.Cap(_chaos, 8)
    --     if c.Success(result) then
    --         c.Done()
    --     end
    -- end

    local result = c.Cap(_selfCritical, 100)
    if c.Success(result) then
        c.Done()
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
