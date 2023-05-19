-- Starts at the magic frame on an encounter with 3 enemies capable of wiping out Alena, Cristo, and Brey in 1 hit
-- Dragonpup and Bisonbear are known enemy types that can do this and come in parties of 3
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _getTargetHp()
    local turn = c.ReadTurn()
    c.Debug('turn: ' .. turn)

    local targetAddr = 0x7300 + turn
    c.Debug('target addr: 0x' .. string.format('%X', targetAddr))
    local target = c.Read(targetAddr)
    c.Debug('Targeting: ' .. target)

    local targetHp
    if target == 0 then
        c.Debug('Targeting Alena')
        targetHp = c.Read(c.Addr.AlenaHP)
    elseif target == 1 then
        c.Debug('Targeting Cristo')
        targetHp = c.Read(c.Addr.CristoHP)
    else
        c.Debug('Targeting Brey')
        targetHp = c.Read(c.Addr.BreyHP)
    end

    c.Debug('Hp: ' .. targetHp)
    return targetHp
end

local function _turnAndFirstHit()
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne() -- x appears
    c.RandomFor(28)
    c.WaitFor(4)
    c.UntilNextInputFrame()
    local result = c.PushAWithCheck()
    if not result then return false end
    c.RandomFor(40)
    c.UntilNextInputFrame()

    -----------------------

    local turn = c.ReadTurn()
    c.Debug('turn: ' .. turn)

    if turn < 4 then
        return c.Bail('A player went first')
    end

    -- For simplicity, let's require that the first enemy targets Alena, it's the most likely anyway
    if turn == 4 and c.Read(c.Addr.E1Target) ~= 0 then
        return c.Bail('Did not target Alena')
    elseif turn == 5 and c.Read(c.Addr.E2Target) ~= 0 then
        return c.Bail('Did not target Alena')
    elseif turn == 6 and c.Read(c.Addr.E3Target) ~= 0 then
        return c.Bail('Did not target Alena')
    end


    -----------------------

    c.WaitFor(2)

    local targetHp = _getTargetHp()
    c.Debug('Need to do this damage: ' .. targetHp)

    c.RndAtLeastOne()
    c.WaitFor(5)

    local dmg = c.ReadDmg()
    c.Debug('Actual dmg: ' .. dmg)

    if dmg < targetHp then
        return c.Bail('Did not do enough damage')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _attackN()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    local targetHp = _getTargetHp()
    c.Debug('Need to do this damage: ' .. targetHp)

    c.RndAtLeastOne()
    c.WaitFor(8)

    local dmg = c.ReadDmg()
    c.Debug('Actual dmg: ' .. dmg)

    if dmg < targetHp then
        return c.Bail('Did not do enough damage')
    end

    c.UntilNextInputFrame()
    c.WaitFor(2)

    return true
end

local function _postDeath()
    c.RndAtLeastOne()
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    c.RndAtLeastOne()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.RandomFor(6)
    c.UntilNextInputFrame()

    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Could not navigate to Tactics')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Could not navigate to Member')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then
        return c.Bail('Could not navigate to Run')
    end
    local result = c.PushAWithCheck()
    if not result then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)

    -- TODO: I do not know what this address seems to change if there is no escape
    local test = c.Read(0x6E5C)
    c.RndAtLeastOne()
    c.WaitFor(12)

    local test2 = c.Read(0x6E5C)
    if test ~= test2 then
        return c.Bail('Run failed')
    end

    c.RandomFor(10)
    c.UntilNextInputFrame()
    c.Log('Finished')
    return true
end

local function _do()
    local result = c.Cap(_turnAndFirstHit, 100)
    if c.Success(result) then
        result = c.Cap(_attackN, 100)
        if c.Success(result) then
            result = c.Cap(_attackN, 100)
            if c.Success(result) then
                result = c.Cap(_postDeath, 100)
                if c.Success(result) then
                    return true
                end
            end
        end
    end

    return false
end

c.Load(2)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
    c.Load(100)
    local result = c.Best(_do, 20)
    if c.Success(result) then
        c.Done()
    end    
end

c.Finish()
