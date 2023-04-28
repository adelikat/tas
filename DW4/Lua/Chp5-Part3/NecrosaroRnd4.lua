-- Starts at the first frame to dismiss "taloon trips" from the previous round
-- Manipulates Necrosar going first, attacking once, and missing, then Taloon builds power
-- Note that taloon tripping is necessary here because "on guard" replaces his attack option due to being so low HP
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function __next()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
end


local function _turn()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    __next()
    c.RndAtLeastOne()
    c.RandomFor(24)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(5)

    if c.ReadTurn() ~= 4 then
        return c.Bail('Necrosaro did not go first')
    end

    if c.Read(c.Addr.E1Action) ~= c.Actions.Attack then
        return c.Bail('Necrosaro did not attack')
    end

    if c.Read(c.Addr.E1Action2) ~= 247 then
        return c.Bail('Necrosaro had a 2nd action')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

   return true
end

local function _miss()    
    c.RndAtLeastOne()
    c.WaitFor(5)

    if c.Read(c.Addr.TaloonHp) == 0 then
        return c.Bail('Did not miss')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _build()
    c.RndAtLeastOne()
    c.RandomFor(30)
    c.WaitFor(5)

    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
        return false
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
    --     c.Log('Turn manipulated')
    --     local rngResult = c.AddToRngCache()
    --     if rngResult then
    --         result = c.Cap(_miss, 10)
    --         if c.Success(result) then
    --             c.Done()
    --         end
    --     else
    --         c.Log('RNG already found')
    --     end
    -- end

    local result = c.Cap(_build, 300, 5)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

