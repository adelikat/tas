-- Starts at the last lag frame after entering the 2nd floor of the light tower
-- Manipulates to the encounter
-- Notes
-- Hector building power or attacking is decided at the time he makes his turn
-- Flamer actions
-- 77 emit fireball
-- 3 cast firebal
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 10
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RandomFor(1)
    c.WaitFor(14)

    c.RndAtLeastOne() -- Flamer appears
    c.WaitFor(1)
    if not emu.islagged() then
        return c.Bail('Lagged at opening')
    end
    c.WaitFor(7)

    c.RndAtLeastOne() -- Lighthouse Bengal appears
    c.WaitFor(1)
    if not emu.islagged() then
        return c.Bail('Lagged at opening')
    end

    c.WaitFor(6)
    c.RndAtLeastOne() -- Flamer appears
    c.WaitFor(1)
    if not emu.islagged() then
        return c.Bail('Lagged at opening')
    end

    c.RandomFor(26)
    c.UntilNextInputFrame()
    c.WaitFor(3) -- Input frame
        
    c.PushA() -- Fight

    -- 0644 seems to always be 0xFF after a successful menu action
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lagged at pressing fight')
        return c.Bail('Lagged at pressing fight')
    end

    c.RandomFor(14)
    c.WaitFor(7)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        c.Log('Could not navigate to spell')
        return c.Bail('Could not navigate to spell')
    end
    
    c.PushA() -- Pick spell
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lagged at pressing spell')
        return c.Bail('Lagged at pressing spell')
    end
    c.WaitFor(6)
    c.PushA() -- Pick Expel
    if c.Read(0x0644) ~= 0xFF then
        c.Log('Lagged at pressing Expel')
        return c.Bail('Lagged at pressing Expel')
    end
    c.WaitFor(7)

    delay = c.DelayUpToWithLAndR(c.maxDelay)
    c.PushA() -- Flamer-A
    c.PushA() -- sometimes it can lag here
    c.RandomFor(28)
    c.WaitFor(4)
    -------
    c.AddToRngCache()
    
    -- if c.Read(c.Addr.E2Action) ~= 67 then
    --     return c.Bail('Lighthouse Bengal will not attack')
    -- end

    -- if c.Read(c.Addr.E3Action) ~= 67 then
    --     return c.Bail('Flamer-B will not attack')
    -- end

    local turn = c.ReadTurn()

    if turn == 4 then
        return c.Bail('Flamer-A cannot go first')
    end

    local bengalTarget = c.Read(c.Addr.E2Target)
    local bengalAction = c.Read(c.Addr.E2Action)

    local flamerBTarget = c.Read(c.Addr.E3Target)
    local flamerBAction = c.Read(c.Addr.E3Action)
    

    if bengalTarget == 0 or bangalTarget == 3 then
        return c.Bail('Bengal targeted Hero or Hector')
    end

    if flamerBTarget == 0 or flamerBTarget == 3 then
        return c.Bail('Flamer targeted Hero or Hector')
    end

    if bengalTarget == flamerBTarget then
        return c.Bail('Flamer-B and Lighthouse Bengal targeted the same character')
    end

    local heroO = c.ReadBattleOrder1()
    local naraO = c.ReadBattleOrder2()
    local maraO = c.ReadBattleOrder3()
    local hectO = c.ReadBattleOrder4()
    local flmAO = c.ReadBattleOrder5()
    local bengO = c.ReadBattleOrder6()
    local flmBO = c.ReadBattleOrder7()

    if flmAO < heroO then
        return c.Bail('Flamer-A went before Hero')
    end

    if maraO < 2 then
        return c.Bail('Mara too high in battle order')
    end

    -- We only need to be concerned about Hector's action if he goes first
    -- Otherwise it can be manipulated later
    if turn == 3 and c.Read(c.Addr.P4Action) ~= 62 then
        return c.Bail('Hector went first but did not build power')
    end

    -- Addresses change after someone's action apparently
    if turn == 6 and flamerBAction ~= 67 then
        return c.Bail('Flamer-B went first but did not attack')
    end

    if turn == 5 and bengalAction ~= 67 then
        return c.Bail('Bengal went first but did not attack')
    end

    if bengalTarget == 2 and maraO < bengO then
        return c.Bail('Begnal targeted Mara but Mara will go first')
    end

    if flamberBTarget == 2 and maraO < flmBO then
        return c.Bail('Flamer-B targeted Mara but Mara will go first')
    end

    if bengalAction == 86 then
        return c.Bail('Bengal did roar')
    end

    c.Log('Turn candidate found')
    c.Save(string.format('LightHouse-Rnd1Candidate-%s-Rng2-%s-Rng1-%s', emu.framecount(), c.ReadRng2(), c.ReadRng1()))

    c.UntilNextInputFrame()
    c.WaitFor(2)
    
    
    return true
end

-- Depends on a very specific turn order that I happened to get
local function _actions()
    c.RndAtLeastOne()
    c.WaitFor(5)
    if c.Read(c.Addr.MaraHp) > 0 then
        return c.Bail('Mara did not die')
    end
    c.WaitFor(50)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x damage points
    c.WaitFor(16)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- Mara passes away
    c.RandomFor(25)
    c.UntilNextInputFrame()

    if c.Read(c.Addr.P4Action) ~= 62 then
        return c.Bail('Hector did not build power')
    end

    c.WaitFor(2)
    c.RndAtLeastOne() -- Hector building up power
    c.RandomFor(25)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(15)
    if c.Read(c.Addr.E1Hp) > 0 then
        return c.Bail('Flamer-A was not expelled')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(62)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(5)
    if c.Read(c.Addr.NaraHp) > 0 then
        return c.Bail('Mara did not die')
    end
    c.WaitFor(30)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    --_tempSave(4)
    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_actions, 500)
    if c.Success(result) then
        c.Done()
    end
    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
