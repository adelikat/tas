-- Starts at the first frame to dismiss "terrific blow" from the previous round
-- Hero must be the last action of round 2
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
    c.RndAtLeastOne()
    c.WaitFor(47)

    c.RndAtLeastOne()
    c.RandomFor(26)
    c.WaitFor(5)
    c.UntilNextInputFrame()
   
    if not c.PushAWithCheck() then return false end
    c.RandomFor(8)
    c.WaitFor(6)
    if not c.PushAWithCheck() then return false end
    
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(10)

    c.AddToRngCache()

    ------------------
    local turn = c.ReadTurn()
    if turn > 1 then
        return c.Bail('Bakor went first')
    end

    if turn == 1 and c.Read(c.Addr.P2Action) ~= c.Actions.Attack then
        return c.Bail('Taloon went first but did not attack')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

local function _crit()
    c.RndAtLeastOne()
    c.WaitFor(6)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    if dmg < 100 then
        return c.Bail('Did not do enough damage')
    end

    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
	local result = c.Cap(_turn, 100)
	if c.Success(result) then
        local result = c.Cap(_crit, 8)
        if c.Success(result) then
            c.Done()
        end
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()



