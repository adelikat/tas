-- Starts from the frame to advance the menu that will get a critical hit
-- Note that the previous script records this event, so some rewinding will be necessary
-- Manipulates round 2
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
--c.BlackscreenMode()
c.Load(5)
local ragnarStartHp = addr.RagnarHp:Read()


local function _turn()
    c.BattleAdvance()
    c.BattleAdvance()
    c.BattleAdvance()
    c.RandomAtLeastOne()
    c.RandomFor(20)
    c.WaitFor(5)

    if not c.PushAWithCheck() then return false end -- Attack
    c.RandomWithoutA()
    c.WaitFor(3)
    c.PushA()
    c.RandomFor(25)

    if not c.IsE1Turn then return false end
    if not c.IsE1Attacking() then
        return c.Bail('Saro did not attack')
    end

    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)

    c.RngCache:Add()

    c.RandomAtLeastOne()
    c.WaitFor(5)
    local currHp = addr.RagnarHp:Read()
    --local dmg = ragnarStartHp - currHp;
    --c.Log('HP diff: ' .. dmg)
    --c.Log('dmg: ' .. addr.Dmg:Read())
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
    c.BattleAdvance()

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
    c.WaitFor(6)

    c.RngCache:Add()

    local dmg = addr.Dmg:Read()
    c.Debug(string.format('dmg: %s', dmg))
    if dmg < 58 then
        return c.Bail('Did not get critical')
    end

    c.Log(string.format('Got %s dmg', dmg))
    if dmg < 60 then
        return c.Bail('Did not do enough dmg')
    end

    return true
end

while not c.IsDone() do
    -- local result = c.Cap(_turn, 100)
    -- if c.Success(result) then
    --     c.Done()
    -- end

    local result = c.Cap(_critical, 100)
    if c.Success(result) then
        c.Done()
    end
    
    c.RngCache:Log()
end