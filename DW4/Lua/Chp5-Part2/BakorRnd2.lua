-- Starts at the first frame to dismiss "A attacks" from the previous round
-- Hero must be the last action of round 1
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
    if c.Read(c.Addr.E1Action) ~= 67 then
        return c.Bail('Bakor did not attack')
    end

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction ~= c.Actions.Attack then
        c.Log('Taloon Action: ' .. taloonAction)
    end

    if taloonAction ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
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
        c.Done()
	end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()



