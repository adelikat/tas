-- Starts at the last frame to dismiss "Gigademon is writhing after tripping" from round 1
-- Manipulates Taloon going first, building power, then Gigademon attacking, then being on guard
-- Notes
-- Giga action 1 will never be "On Guard"
-- Giga action 2 will always be "On Guard"
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(20)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(32)
    c.WaitFor(14)

    c.AddToRngCache()
    -- ----------------------------------------------

    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    -- if c.Read(c.Addr.E1Action) ~= 67 then
    --     return c.Bail('Gigademon did not attack')
    -- end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction == 247 then
        c.Log('Taloon did not make up his mind yet')
        return false
    end

    c.Debug('Taloon: ' .. c.TaloonActions[taloonAction])
    if c.Read(c.Addr.P2Action) ~= c.Actions.BuildingPower then
        return c.Bail('Taloon did not build power')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _miss()
    local origHp = c.Read(c.Addr.TaloonHp)
    c.Debug('origHp: ' .. origHp)
    c.RndAtLeastOne()
    c.RandomFor(37)
    c.WaitFor(9)
    if not emu.islagged() then
        c.Log('unexpected input frame')
        return false
    end
    c.WaitFor(1)
    if emu.islagged() then
        c.Log('unexpected lag frame')
        return false
    end
    c.WaitFor(1)
    c.RndAtLeastOne()
    c.WaitFor(6)
    local currHp = c.Read(c.Addr.TaloonHp)
    c.Debug('currHP: ' .. currHp)
    if currHp < origHp then
        return c.Bail('Failed to miss')
    end

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
        c.Log('Turn manipulated')
        local result = c.ProgressiveSearch(_miss, 250, 1)
        if c.Success(result) then
            c.Done()
        end
    end

    -- c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

