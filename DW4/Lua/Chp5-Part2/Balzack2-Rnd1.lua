-- Starts at the last lag frame after entering Balzack's chambers
-- manipulates walking to him and starting the fight
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 5

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _do()
    c.RandomFor(2)
    c.WaitFor(13)
    c.RndAtLeastOne()
    c.RandomFor(25)
    c.WaitFor(4)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(4)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to spell')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to parry')
    end
    c.DelayUpToWithLAndR(c.maxDelay)
    if not c.PushAWithCheck() then return false end 
    c.RandomFor(43)

    c.AddToRngCache()
    -------------------------------
    local balzackAction = c.Read(c.Addr.E1Action)
    if balzackAction ~= 67 then
        return c.Bail('Balzack did not attack')
    end

    local balzackTarget = c.Read(c.Addr.E1Target)
    if balzackTarget ~= 2 then
        return c.Bail('Balzack did not target Ragnar')
    end

    -- if c.ReadTurn() ~= 0 then
    --     return c.Bail('Hero did not go first')
    -- end

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
        return c.Bail('Taloon did not build power')
    end

    --Seems to be the 2nd action of Balzack, possibly other bosses
    if c.Read(0x7334) ~= 67 then
        return c.Bail('Balzack 2nd action was not an attack')
    end
    
    -------------------------------
    
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_do, 100)
    if c.Success(result) then
        c.Done()
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
