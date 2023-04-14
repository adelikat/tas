-- Starts at the last lag frame upon entering ElfVille
-- Manipulates entering the tree, reviving, taloon,
-- picking up Lucia, and the Sword, and returning to Stancia
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _stairs(direction)
    c.PushFor(direction, 1)
    c.RandomForNoA(20)
    c.WaitFor(1)
end

local function _enterTree()
    if not c.WalkUp(10) then return false end
    _stairs('Up')
    _stairs('Up')
    _stairs('Up')
    _stairs('Up')
    c.PushUp()
    c.RandomFor(20)
    c.UntilNextInputFrame()
    return true
end

local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 6 },
        { ['Right'] = 8 },
        { ['Up'] = 5 },
        { ['Left'] = 2 },
        { ['Up'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    local result = c.WalkMap({
        { ['Right'] = 7 },
        { ['Down'] = 8 },
        { ['Right'] = 5 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.Item() then return false end
    if not c.PushAWithCheck() then return false end -- Pick Item
    c.UntilNextLagFrame()
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Hero
    c.WaitFor(3)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Basic Clothes
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return false end
    if not c.PushAWithCheck() then return false end -- Pick Discard
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Yes
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.DismissDialog()
    c.ChargeUpWalking()
    if not c.BringUpMenu() then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.ChargeUpWalking()
    if not c.BringUpMenu() then return false end
    if not c.Item() then return false end
    if not c.PushAWithCheck() then return false end -- Pick Item
    c.WaitFor(3)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Hero
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 19 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 20 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 21 then return false end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 22 then return false end -- Zenithian Shield
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 23 then return false end -- Leaf of world tree
    if not c.PushAWithCheck() then return false end -- Pick Leaf
    c.WaitFor(3)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Use
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then return false end
    if not c.PushAWithCheck() then return false end -- Pick Taloon
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.DismissDialog()
    c.ChargeUpWalking()
    result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 3 },
        { ['Down'] = 2 },
        { ['Left'] = 2 },
        { ['Up'] = 6 },
        { ['Left'] = 4 },
        { ['Up'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    local result = c.WalkMap({
        { ['Right'] = 2 },
        { ['Up'] = 3 },
        { ['Right'] = 2 },
        { ['Up'] = 4 },
        { ['Right'] = 3 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
        { ['Down'] = 1 },
        { ['Right'] = 1 },
        { ['Down'] = 11 },
        { ['Left'] = 11 },
        { ['Down'] = 4 },
        { ['Left'] = 7 },
        { ['Up'] = 9 },
        { ['Left'] = 2 },
        { ['Up'] = 4 },
        { ['Left'] = 3 },
        { ['Up'] = 7 },
        { ['Right'] = 9 },
        { ['Down'] = 5 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Right'] = 2},
        { ['Up'] = 4 },
        { ['Left'] = 12 },
        { ['Down'] = 2 },
        { ['Left'] = 1 },
        { ['Down'] = 1 },
        { ['Left'] = 1 },
        { ['Down'] = 3 },
        { ['Right'] = 4 },
        { ['Down'] = 1 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 1 },
        { ['Down'] = 2 },
        { ['Right'] = 11 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 1 },
        { ['Right'] = 1 },
        { ['Up'] = 3 },
        { ['Right'] = 8 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor5()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 4 },
        { ['Down'] = 2 },
        { ['Left'] = 1 },
        { ['Down'] = 3 },
        { ['Left'] = 2 },
        { ['Down'] = 3 },
        { ['Left'] = 1 },
        { ['Down'] = 2 },
    })
    c.PushRight()
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.ChargeUpWalking()
    local result = c.WalkMap({
        { ['Right'] = 1 },
        { ['Down'] = 3 },
        { ['Right'] = 2 },
        { ['Down'] = 2 },
        { ['Right'] = 8 },        
    })
    if not c.BringUpMenu() then return false end
    if not c.Search() then return false end
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(2)
    c.DismissDialog()
    c.ChargeUpWalking()
    if not c.BringUpMenu() then return false end
    c.HeroCastReturn()
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
    if not c.PushAWithCheck() then return false end
    c.RandomFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_enterTree, 12)
    if c.Success(result) then
        local result = c.Best(_floor1, 12)
        if c.Success(result) then
            local result = c.Best(_floor2, 12)
            if c.Success(result) then
                local result = c.Best(_floor3, 12)
                if c.Success(result) then
                    local result = c.Best(_floor4, 12)
                    if c.Success(result) then
                        local result = c.Best(_floor5, 12)
                        if c.Success(result) then
                            return true
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

    local result = c.Cap(_do, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()

