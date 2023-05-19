-- Starts at the first frame to dismiss the 'Terrific Blow' dialog from the 3rd hit from reinforcements
-- Manipulates Necro going first, attacking twice, missing both times, and taloon building power
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
    c.RandomFor(24)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(40)
    c.WaitFor(5)

    c.AddToRngCache()
    if c.ReadTurn() ~= 4 then
        return c.Bail('Necro did not go first')
    end

    if c.Read(c.Addr.E1Action) ~= c.Actions.Attack then
        return c.Bail('Necro did not attack')
    end

    if c.Read(c.Addr.E1Action2) ~= c.Actions.Attack then
        return c.Bail('Necro did not attack')
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

local function _miss2()
    -- Necro can change his mind after the first attack
    if c.Read(c.Addr.E1Action) ~= c.Actions.Attack then
        return c.Bail('Necro did not attack')
    end

    if c.Read(c.Addr.E1Action2) ~= c.Actions.Attack then
        return c.Bail('Necro did not attack')
    end

    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    if c.Read(c.Addr.E1Action) ~= c.Actions.Attack then
        return c.Bail('Necro did not attack')
    end

    if c.Read(c.Addr.E1Action2) ~= c.Actions.Attack then
        return c.Bail('Necro did not attack')
    end

    return _miss()
end

local function _buildPower()
    c.RndAtLeastOne()
    c.RandomFor(25)
    c.UntilNextInputFrame()
    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
        return false
    end
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

    -- local result = c.Cap(_turn, 300, 5)
    -- if c.Success(result) then
    --     --c.Log('Turn manipulated')
    --     result = c.ProgressiveSearch(_miss, 10, 1)
    --     if c.Success(result) then
    --         c.Log('Miss 1 found')
    --         _tempSave(4)
    --         c.Save(string.format('LastMissCandidate-%s-RNG2-%s-RNG1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))
    --         result = c.ProgressiveSearch(_miss2, 250, 5)
    --         if c.Success(result) then
    --             c.Done()
    --         end
    --     end
    -- end

    local result = c.Cap(_buildPower, 300, 5)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

