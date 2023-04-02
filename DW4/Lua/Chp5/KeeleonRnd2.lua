-- Starts at the first frame to dismiss the last dialog from round 1
-- Taloon building power = 62
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
    c.RandomFor(27)
    c.UntilNextInputFrame()
    c.WaitFor(3)
    if not c.PushAWithCheck() then return false end -- Fight
    c.RandomFor(8)
    c.WaitFor(6)
    if not c.PushAWithCheck() then return false end -- Attack
    c.WaitFor(4)
    delay = c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end -- Keeleon
    c.RandomFor(20)
    c.WaitFor(20)

    c.AddToRngCache()

    ---------------------------------

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    if c.ReadBattleOrder1() > c.ReadBattleOrder5() then
        return c.Bail('Hero did not go 2nd')
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
        c.Log('Delay: ' .. delay)
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

