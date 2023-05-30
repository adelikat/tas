-- Starts from the magic frame
-- Manipulates equipping the sowrd of malice, getting 2 misses, and a critical hit on the eyeball
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(4)
local ragnarStartHp = addr.RagnarHp:Read()

local function _turnAndMiss()
    c.RandomFor(2)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.RandomAtLeastOne()
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.RandomAtLeastOne()
    c.RandomFor(20)
    c.WaitFor(7)
    if not c.PushDownWithCheck(17) then return false end
    c.RandomWithout(1, 'A', 'B', 'Up', 'Down') -- L, R, and Start are valid here
    if not c.PushDownWithCheck(18) then return false end
    c.RandomWithout(1, 'A', 'B', 'Up', 'Down')
    if not c.PushDownWithCheck(19) then return false end
    if not c.PushAWithCheck() then return false end -- Item
    c.RandomWithout(1, 'Up')
    c.WaitFor(5)
    if not c.PushUpWithCheck(31) then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(8)
    if not c.PushDownWithCheck(16) then return false end
    
    if not c.PushAWithCheck() then return false end
    c.RandomWithout(1, 'Down')
    c.WaitFor(1)
    if not c.PushDownWithCheck(17) then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomWithout(1, 'Down')
    c.WaitFor(5)
    if not c.PushDownWithCheck(17) then return false end
    
    if not c.PushAWithCheck() then return false end
    c.RandomFor(23)

    c.RngCache:Add()

    if not c.IsE1Turn() then
        return c.Bail('Saro did not go first')
    end

    if not c.IsE1Attacking() then
        return c.Bail('Saro did not attack')
    end

    if not c.IsE2Attacking() then
        return c.Bail('Eyeball did not attack')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    c.RandomAtLeastOne()
    c.WaitFor(5)
    local currHp = addr.RagnarHp:Read()
    local dmg = ragnarStartHp - currHp;
    --c.Log('HP diff: ' .. dmg)
    --c.Log('dmg: ' .. addr.Dmg:Read())
    if currHp < ragnarStartHp then
        return c.Bail('Saro did not miss')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    return true
end

local function _miss2()
    c.RandomAtLeastOne()
    c.RandomFor(10)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    if not c.IsE2Attacking() then
        return c.Bail('Eyeball is non guard')
    end

    c.RandomAtLeastOne()
    c.WaitFor(5)

    local currHp = addr.RagnarHp:Read()
    local dmg = ragnarStartHp - currHp;
    c.Log('HP diff: ' .. dmg)
    c.Log('dmg: ' .. addr.Dmg:Read())

    if currHp < ragnarStartHp then
        return c.Bail('Saro did not miss')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    return true
end

-- Starts at the frame that will cause the miss, note that the previous function manipulates that miss
-- Some replaying will be needed to use this
local function _critical()
    -- Causes the nimbly, do not delay here
    c.RandomAtLeastOne()
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    -- This assumes all options were exhausted that did not include a delay
    local flip = c.Flip()
    if flip then
        c.WaitFor(1)
    end
    c.RandomAtLeastOne()
    c.RandomFor(10)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    if not flip then
        c.WaitFor(1)
    end
    c.RandomAtLeastOne()
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.RandomAtLeastOne()
    c.WaitFor(6)

    c.RngCache:Add()


    if addr.Dmg:Read() < 42 then
        return c.Bail('Did not get critical')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    return true
end

while not c.IsDone() do
    -- local result = c.Cap(_turnAndMiss, 100)
    -- if c.Success(result) then
    --     c.Log('Miss 1 manipulated')
    --     local result = c.Cap(_miss2, 250)
    --     if c.Success(result) then
    --         c.Done()
    --     end
    -- end

    local result = c.Cap(_critical, 100)
    if c.Success(result) then
        c.Done()
    end
    
    c.RngCache:Log()
end