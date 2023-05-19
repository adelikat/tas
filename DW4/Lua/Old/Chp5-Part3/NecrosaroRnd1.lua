-- Starts at the magic frame at the start fo the fight with Necrosaro
-- Manipulates Necrosar going first, attacking twice, both misses, an d
-- Manipulates leaving the srine and entering Necrosaro's palace, then taloon building power
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(2)
    c.WaitFor(13)
    c.RndAtLeastOne()
    c.RandomFor(22)
    c.WaitFor(5)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(27)
    c.WaitFor(5)

    ------------------
    if c.ReadTurn() ~= 4 then
        return c.Bail('Necrosaro did not go first')
    end

    if c.Read(c.Addr.E1Action) ~= 67 then
        c.Log('Not known to be possible, necro did not attack')
        c.Save('Investigate-NecroAction-'..c.Read(c.Addr.E1Action))
        return c.Bail('Necrosaro did not attack')
    end

    if c.Read(c.Addr.E1Action2) ~= 67 then
        c.Log('Not known to be possible, necro did not attack')
        c.Save('Investigate-NecroAction2-'..c.Read(c.Addr.E1Action2))
        return c.Bail('Necrosaro did not attack')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

   return true
end

local function _miss()
    local origHp = c.Read(c.Addr.TaloonHp)
    c.Debug('origHp: ' .. origHp)
    c.RndAtLeastOne()
    c.WaitFor(6)
    local currHp = c.Read(c.Addr.TaloonHp)

    c.Debug('currHp: ' .. currHp)
    if currHp ~= origHp then
        return c.Bail('Did not miss')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    return true
end

local function _miss2()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    return _miss()
end

local function _buildPower()
    c.RndAtLeastOne()
    c.RandomFor(30)
    c.WaitFor(10)

    c.AddToRngCache()
    local tAction = c.Read(c.Addr.P2Action)
    if tAction == 247 then
        c.Log('Taloon did not make up his mind yet')
        return false
    end

    c.Debug('Taloon action: ' .. c.TaloonActions[tAction])
    
    if tAction ~= c.Actions.BuildingPower then
        return c.Bail('Did not build power')
    end
    c.UntilNextInputFrame()
    c.WaitFor(2)
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)
    -- local result = c.Cap(_turn, 10)
    -- if c.Success(result) then
    --     local rngResult = c.AddToRngCache()
    --     if rngResult then
    --         result = c.Cap(_miss, 5)
    --         if c.Success(result) then
    --             c.Log('Miss 1 found')
    --             _tempSave(3)
    --             result = c.ProgressiveSearch(_miss2, 250, 5)
    --             if c.Success(result) then
    --                 c.Done()
    --             end
    --         end
    --     else
    --         c.Log('RNG already found')
    --     end
    -- end

    local result = c.Cap(_buildPower, 100)
    if c.Success(result) then
        c.Done()
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

