-- Starts at the first frame to dismiss x damage points, to nara
-- Will manipulates the Nara dies menu, for extra luck manipulation
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 100
c.maxDelay = 0
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _turn()
    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(43)
    c.UntilNextInputFrame()
    c.WaitFor(3)
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Lag at Fight menu')
    end
    c.WaitFor(5)
    c.RandomFor(10)
    c.WaitFor(5)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Spell')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Lag at Spell')
    end
    c.WaitFor(6)
    if c.ReadMenuPosY() ~= 16 then
        return c.Bail('Lag at spell menu')
    end

    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Lag at Fight menu')
    end
    c.WaitFor(6)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Flamer')
    end
    c.PushA()
    if c.Read(0x0644) ~= 0xFF then
        return c.Bail('Lag at Flamer')
    end

    c.RandomFor(30)
    c.WaitFor(5)
    c.UntilNextInputFrame()

    -----------------------------------------

    local turn = c.ReadTurn()
    if turn ~= 0 then
        return c.Bail('Hero did not go first')
    end

    local heroO = c.ReadBattleOrder1()
    local hectO = c.ReadBattleOrder4()
    local bengO = c.ReadBattleOrder6()
    local flmBO = c.ReadBattleOrder7()

    if flmBO < heroO then
        return c.Bail('Flamer-B must not go before the Hero')
    end

    if bengO < hectO then
        return c.Bail('Bengal must not go before Hector')
    end

    c.WaitFor(2)
   
    _tempSave(4)
    return true
end

-- Depends on Hero going first
local function _expel()
    c.RndAtLeastOne()
    c.WaitFor(15)
    if c.Read(c.Addr.E3Hp) > 0 then
        return c.Bail('Flamer-B was not expelled')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)
    --_tempSave(4)
    return true
end

local function _critical()
    delay = c.DelayUpTo(c.maxDelay)
    c.RndAtLeastOne()
    c.RandomFor(48)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    delay = delay + c.DelayUpTo(c.maxDelay - delay)
    c.RndAtLeastOne()
    c.WaitFor(10)
    local dmg = c.ReadDmg()
    c.Debug('dmg: ' .. dmg)
    return dmg >= 35
end

c.Load(4)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Cap(_critical, 1000)
    if result then
        c.Log('Delay: ' .. delay)
        c.Done()
    end
    -- local result = c.Cap(_turn, 500)
    -- if c.Success(result) then
    --     c.Log('Turn manipulated')
    --     result = c.Cap(_expel, 5)
    --     if result then
    --         c.Done()
    --     end
    -- end
end

c.Finish()
