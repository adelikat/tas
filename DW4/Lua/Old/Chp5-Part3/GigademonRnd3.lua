-- Starts at the last frame to dismiss "Taloon eludes nimbly", with Gigademon on guard as the next action, in round 2
-- Manipulates Taloon going first, calling reinforcements, and delivering a critical hit
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.RandomFor(20)
    c.WaitFor(6)
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
    c.RandomFor(27)
    c.WaitFor(4)
    if not c.PushAWithCheck() then return false end
    c.RandomFor(30)
    c.WaitFor(13)
    if c.ReadTurn() ~= 1 then
        return c.Bail('Taloon did not go first')
    end

    local taloonAction = c.Read(c.Addr.P2Action)
    if taloonAction == 247 then
        c.Debug('Taloon did not make up his mind yet')
        return false
    end

     c.Debug('Taloon: ' .. c.TaloonActions[taloonAction])
    if c.Read(c.Addr.P2Action) ~= c.Actions.Reinforcements then
        return c.Bail('Taloon did not call for reinforcements')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _critical1()
    c.RndAtLeastOne()
    c.RandomFor(80)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(10)
    c.WaitFor(7)

    c.RndAtLeastOne()
    c.WaitFor(10)
    if c.ReadDmg() < 220 then
        return false
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    
    return true
end

local function _critical2()
    c.RndAtLeastOne()
    c.RandomFor(40)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.RndAtLeastOne()
    c.RandomFor(10)
    c.WaitFor(7)

    c.RndAtLeastOne()
    c.WaitFor(10)
    if c.ReadDmg() < 220 then
        return false
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
        c.Log('Turn manipulated')
        _tempSave(4)
        local result = c.ProgressiveSearch(_critical1, 100, 1)
        if c.Success(result) then
            c.Log('Crit 1 manipulated')
            _tempSave(5)
            local result = c.ProgressiveSearch(_critical2, 100, 2)
            if c.Success(result) then
                c.Done()
            end
        end
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

