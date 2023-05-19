-- Starts at the first frame to dismiss the "Terrific Blow" dialog in round 1
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.WaitFor(55)
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(50)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(5)
    c.AddToRngCache()
    ----------------------------
    if c.ReadTurn() == 4 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= 67 then
        return c.Bail('Taloon did not attack')
    end
    ----------------------------

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

local function _taloonCritical()
    c.RndAtLeastOne()
    c.WaitFor(5)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 220 then
        return c.Bail('Taloon did not do enough damage')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

c.Load(5)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)

    local result = c.Cap(_turn, 100)
    if c.Success(result) then
        c.Log(string.format('Turn manipulated (RNG %s)', c.RngCacheLength()))
        result = c.Cap(_taloonCritical, 10)
        if c.Success(result) then
            c.Done()
        end
    end
end

c.Finish()



