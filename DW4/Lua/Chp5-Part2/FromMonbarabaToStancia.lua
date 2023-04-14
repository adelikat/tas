-- Starts at the last lag frame upon entering Monbaraba
-- Manipulates picking up Panon and returning to Stancia, changing party formation, and entering
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _intoTheatre()
    if not c.WalkUp(17) then return false end
    result = c.Best(c.WalkUpToCaveTransition, 5)
    if not result then return false end
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 1 },
        { ['Up'] = 2 },
        { ['Right'] = 1 },
        { ['Up'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _leave()
    if not c.WalkUp(5) then return false end
    result = c.Best(c.WalkUpToCaveTransition, 5)
    if not result then return false end
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Left'] = 3 },
        { ['Up'] = 4 },
        { ['Left'] = 1 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
    })    
    if not result then return false end
    c.PushUp()
    c.RandomForNoA(20)
    c.WaitFor(1)
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 5 },
        { ['Up'] = 1 },
    })    
    if not result then return false end
    result = c.Best(c.WalkUpToCaveTransition, 5)
    if not result then return false end
    if not c.WalkUp(4) then return false end
    c.PushRight()
    c.PushA()
    c.RandomFor(13)
    c.WaitFor(1)
    c.PushUp()
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(79)
    if not c.BringUpMenu() then return false end
    if not c.HeroCastReturn() then return false end
    c.PushUp()
    if c.ReadMenuPosY() ~= 31 then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 16 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame(0)
    return true

end

local function _downCharList(expectedMenu)
    c.PushDown()
    if c.ReadMenuPosY() ~= expectedMenu then
        return false
    end
    c.WaitFor(3)
    if emu.islagged() then
         return c.Bail('Did not end on an input frame')
    end

    return true
end

local function _enterStancia()
    c.ChargeUpWalking()
    -- if not c.BringUpMenu() then return false end
    -- if not c.Item() then return false end
    -- if not c.PushAWithCheck() then return false end
    -- c.WaitFor(10)
    -- c.UntilNextInputFrame()
    -- if not c.PushAWithCheck() then return false end
    -- c.WaitFor(5)
    -- c.UntilNextInputFrame()
    -- if not c.PushDownWithCheck(17) then return false end
    -- c.RndLeftOrRight()
    -- if not c.PushDownWithCheck(18) then return false end
    -- c.RndLeftOrRight()
    -- if not c.PushDownWithCheck(19) then return false end
    -- if not c.PushAWithCheck() then return false end
    -- c.WaitFor(2)
    -- c.UntilNextInputFrame()
    -- if not c.PushDownWithCheck(17) then return false end
    -- c.RndLeftOrRight()
    -- if not c.PushDownWithCheck(18) then return false end
    -- if not c.PushAWithCheck() then return false end
    -- c.RandomFor(5)
    -- c.UntilNextInputFrame()
    -- c.WaitFor(2)
    -- c.UntilNextInputFrame()
    -- if not c.PushAWithCheck() then return false end
    -- c.WaitFor(10)
    -- c.UntilNextInputFrame()
    -- c.WaitFor(2)
    -- c.DismissDialog()
    -- c.ChargeUpWalking()
    if not c.BringUpMenu() then return false end
    if not c.Tactics() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.RandomFor(2)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    if not _downCharList(17) then return false end
    if not _downCharList(18) then return false end
    if not _downCharList(19) then return false end
    if not _downCharList(20) then return false end
    if not _downCharList(21) then return false end
    if not _downCharList(22) then return false end
    if not _downCharList(23) then return false end
    if not _downCharList(24) then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 25 then
        return false
    end
    c.WaitFor(2)
    if not c.PushAWithCheck() then return false end -- Pick Panon
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Hero
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Taloon
    c.WaitFor(5)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not _downCharList(17) then return false end
    if not _downCharList(18) then return false end
    if not _downCharList(19) then return false end
    if not _downCharList(20) then return false end
    if not _downCharList(21) then return false end
    if not _downCharList(22) then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 23 then
        return false
    end
    c.WaitFor(6)
    if not c.PushAWithCheck() then return false end -- Pick END
    c.RandomFor(20)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.DismissDialog()
    c.RandomForNoA(30)
    c.WaitFor(1)
    if not c.WalkUp() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    local result = c.Cap(_intoTheatre, 12)
    if c.Success(result) then
        local result = c.Cap(_leave, 12)
        if c.Success(result) then
            local result = c.Best(_enterStancia, 12)
            if c.Success(result) then
                return true
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
end

c.Finish()

