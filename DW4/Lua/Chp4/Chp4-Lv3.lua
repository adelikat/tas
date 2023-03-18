-- Starts at the last lag frame entering Keeleon with Orin
-- Manipulates opening the door and entering

--Mara start stats
-- Str 3
-- Agility 5
-- Vit 12
-- Int 4
-- Luck 6
-- Max HP 16
-- Max MP 9

local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 43
local delay = 0


local function _toLvUp()
    -- If getting spell
    -- c.RndAorB()
    -- c.WaitFor(20)
    -- c.UntilNextInputFrame()

    delay = c.DelayUpToForLevels(20)
    c.RndAorB()
    c.WaitFor(200)
    c.UntilNextInputFrame()

    return true
end

local function _toVit()
    local origStr = c.Read(c.Addr.MaraStr)
    local origAg = c.Read(c.Addr.MaraAg)
    local origVit = c.Read(c.Addr.MaraVit)
    local origInt = c.Read(c.Addr.MaraInt)
    c.RandomFor(1)
    c.WaitFor(10)
    c.UntilNextInputFrame()

    local currStr = c.Read(c.Addr.MaraStr)
    if currStr > origStr then
        return c.Bail('Got Str')
    end

    local currAg = c.Read(c.Addr.MaraAg)
    if currAg == origAg then
        c.Log('Jackpot, no Agility')
        c.Save('Lv2-AgSkip-' .. emu.framecount())
        return true
    end

    local agDelay = 0
    local agUp = currAg - origAg
    c.Debug('Agility increase: ' .. agUp)
    if agUp == 1 then
        agDelay = 1
    end

    local actualDelay = delay + c.DelayUpToForLevels(agDelay + 10)
    c.RndAorB()

    c.WaitFor(10)
    c.UntilNextInputFrame()

    c.AddToRngCache()

    local currVit = c.Read(c.Addr.MaraVit)
    if currVit > origVit then
        return c.Bail('Got Vitality')
    end

    local currInt = c.Read(c.Addr.MaraInt)
    if currInt == origInt then
        c.Log('Jackpot, no Int')
        c.Save('Lv2-IntSkip-' .. emu.framecount())
        return true
    end

    if actualDelay > 0 then
        c.Log('Used ag delay')
    end
    
    return true
end

local function _finish()
    local origLuck = c.Read(c.Addr.MaraLuck)
    delay = c.DelayUpToForLevels(c.maxDelay)
    c.RndAorB()
    c.WaitFor(10)
    c.UntilNextInputFrame()

    local currLuck = c.Read(c.Addr.MaraLuck)
    local inc = currLuck - origLuck
    c.Debug('Luck inc: ' .. inc)
    if inc > 0 then
        c.AddToRngCache()
        return c.Bail('Got luck')
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)
    
    -- local result = c.Cap(_toLvUp, 100)
    -- if result then    
    --     result = c.Cap(_toVit, 100)
    --     if result then
    --         c.Done()
    --     end 
    -- end

    local result = c.Cap(_finish, 100)
    if result then
        c.Log('Luck skip found, delay: ' .. delay)
        if delay == 0 then
            c.Done()
        else
            c.Save(9)
            c.maxDelay = delay - 1
            c.Log('New max delay: ' .. c.maxDelay)
        end        
    end

    c.Log('RNG: ' .. c.RngCacheLength())
end

c.Finish()
