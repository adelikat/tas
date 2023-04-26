-- Starts at the last lag frame after the map appears after the Gigademon fight
-- Manipulates leaving the srine and entering Necrosaro's palace
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function __useMedicalHerb()
    local targetHeal = 30
    local origHp = c.Read(c.Addr.TaloonHp)
    c.Debug('orig HP: ' .. origHp)
    c.RandomFor(2)
    c.WaitFor(80)

    local currHp = c.Read(c.Addr.TaloonHp)
    c.Debug('curr HP: ' .. currHp)
    local gain = currHp - origHp
    c.Log(string.format('Healed %s HP', gain))
    if gain ~= targetHeal then
        return c.Bail('Did not heal to target HP value')
    end

    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.DismissDialog()

    return true
end

local function __barrierRight()
    c.PushRight()
    c.RandomFor(14)
    c.WaitFor(5)
    return not c.IsEncounter()
end

local function _heal()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.BringUpMenu() then return false end
    if not c.Item() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(10)
    if not c.PushDownWithCheck(18) then return false end
    c.WaitFor(10)
    if not c.PushDownWithCheck(19) then return false end
    c.WaitFor(9)
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(18) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(19) then return false end

    if not c.PushAWithCheck() then return false end -- Medical Herb
    c.WaitFor(5)
    if not c.PushDownWithCheck(17) then return false end
    if not c.PushAWithCheck() then return false end -- Transfer
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(9)
    if not c.PushAWithCheck() then return false end -- Taloon
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.BringUpMenu() then return false end
    if not c.Item() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(9)
    if not c.PushAWithCheck() then return false end -- Taloon
    c.WaitFor(5)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(18) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(19) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(20) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(21) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(22) then return false end
    c.WaitFor(1)
    if not c.PushDownWithCheck(23) then return false end
    if not c.PushAWithCheck() then return false end -- Medical Herb
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Use
    c.RandomFor(2)
    c.UntilNextInputFrame()
    if not c.PushDownWithCheck(17) then return false end
    if not c.PushAWithCheck() then return false end

    local result = c.Cap(__useMedicalHerb, 50)
    if not result then return false end
    return true
end

local function _finishFloor1()
    if not c.ChargeUpWalking() then return false end
    if not c.WalkDown(7) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    if not __barrierRight() then return false end
    if not __barrierRight() then return false end
    if not __barrierRight() then return false end
    if not __barrierRight() then return false end
    c.PushDown()
    c.RandomFor(14)
    c.WaitFor(5)
    if c.IsEncounter() then return false end
    local result = c.Best(c.WalkDownToCaveTransition, 2)
    if not result then return false end
    if not c.WalkDown(10) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Up'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    if c.GenerateRndBool() then
        c.WalkRight()
        c.WalkLeft()
    else
        c.WalkUp()
        c.WalkDown()
    end    
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor5()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 3 },
        { ['Up'] = 3 },
        { ['Left'] = 1 },
        { ['Up'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _toCastle()
    local result = c.WalkMap({
        { ['Up'] = 5 },
        { ['Right'] = 3 },
        { ['Up'] = 4 },
        { ['Right'] = 3 },
        { ['Down'] = 1 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    if not __barrierRight() then return false end
    if not __barrierRight() then return false end
    if not __barrierRight() then return false end
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Up'] = 2 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_heal, 12)
    if c.Success(result) then
        local result = c.Best(_finishFloor1, 12)
        if c.Success(result) then
            local result = c.Best(_floor2, 12)
            if c.Success(result) then
                local result = c.Best(_floor3, 12)
                if c.Success(result) then
                    local result = c.Best(_floor4, 12)
                    if c.Success(result) then
                        local result = c.Best(_floor5, 12)
                        if c.Success(result) then
                            local result = c.Best(_toCastle, 12)
                            if c.Success(result) then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do    
	c.Load(100)
    local result = c.Best(_do, 10)
    if c.Success(result) then
        c.Done()
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()

