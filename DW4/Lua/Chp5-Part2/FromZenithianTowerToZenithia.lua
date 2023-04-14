-- Starts at the last lag frame upon arrving at Konenber from Stancia
-- Manipulates taking the baloon to Gottside Island and entering the zenithian tower
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _stairs(count)
    if count == nil then
        count = 1
    end
    for i = 1, count do
        c.PushUp()
        c.RandomFor(20)
        c.WaitFor(1)
        if c.IsEncounter() then
            return false
        end
    end
    return not c.IsEncounter()
end

local function _stairsDown()
    c.PushDown()
    c.RandomFor(20)
    c.WaitFor(1)
    return not c.IsEncounter()
end

local function _equipZenithianGear()
    if not c.BringUpMenu() then return false end
    c.PushDown()
    if c.ReadMenuPosY() ~= 17 then
        return c.Bail('Unable to navigate to Status')
    end
    c.WaitFor(1)
    c.PushDown()
    if c.ReadMenuPosY() ~= 18 then
        return c.Bail('Unable to navigate to Equip')
    end
    if not c.PushAWithCheck() then return false end
    c.RandomForLevels(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Hero
    c.RandomFor(12)
    c.UntilNextInputFrame()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushUp()
    if c.ReadMenuPosY() ~= 17 then return c.Bail('Unable to navigate to Sword') end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick sword
    c.RandomFor(10)
    c.WaitFor(6)
    c.UntilNextInputFrame()
    c.PushUp()
    if c.ReadMenuPosY() ~= 16 then return c.Bail('Unable to navigate to Armor') end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick armor
    c.RandomFor(8)
    c.WaitFor(6)
    c.UntilNextInputFrame()
    c.PushUp()
    if c.ReadMenuPosY() ~= 16 then return c.Bail('Unable to navigate to Shield') end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick Shield
    c.RandomFor(10)
    c.WaitFor(6)
    c.UntilNextInputFrame()
    c.PushUp()
    if c.ReadMenuPosY() ~= 16 then return c.Bail('Unable to navigate to Helm') end
    c.WaitFor(2)
    c.UntilNextInputFrame()
    if not c.PushAWithCheck() then return false end -- Pick helm
    c.WaitFor(5)
    c.UntilNextInputFrame()
    return true
end

local function _enterTower()    
    if not _equipZenithianGear() then return false end
    c.ChargeUpWalking()
    _stairs(8)
    c.UntilNextInputFrame()
    
    return true
end

local function _floor1()
    local result = c.WalkMap({
        { ['Up'] = 6 },
        { ['Right'] = 7 },
        { ['Down'] = 1 },
        { ['Right'] = 7 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor2()
    local result = c.WalkMap({
        { ['Down'] = 4 },
        { ['Left'] = 6 },
        { ['Up'] = 1 },
        { ['Left'] = 1 },
    })
    if not result then return false end
    if not c.Cap(_stairs, 100) then return false end
    if not c.Cap(_stairs, 100) then return false end
    if not c.Cap(_stairs, 100) then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    if not c.Cap(_stairs, 100) then return false end
    if not c.Cap(_stairs, 100) then return false end
    if not c.Cap(_stairs, 100) then return false end
    local result = c.WalkMap({
        { ['Up'] = 4 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    if not c.Cap(_stairs, 100) then return false end
    c.PushUp()
    c.RandomFor(20)
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor3()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 2 },
        { ['Up'] = 9 },
        { ['Right'] = 3 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor4()
    local result = c.WalkMap({
        { ['Right'] = 4 },
        { ['Up'] = 4 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor5()
    local result = c.WalkMap({
        { ['Left'] = 4 },
        { ['Down'] = 5 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor6()
    if not _stairsDown() then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 3 },
    })
    if not result then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 8 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor7()
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Left'] = 14 },
        { ['Down'] = 2 },
        { ['Right'] = 11 },
        { ['Down'] = 3 },
        { ['Left'] = 10 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor8()
    local result = c.WalkMap({
        { ['Right'] = 4 },
        { ['Up'] = 1 },
    })
    if not result then return false end
    if not _stairs() then return false end
    if not c.WalkUp() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor9()
    local result = c.WalkMap({
        { ['Up'] = 3 },
        { ['Right'] = 4 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor10()
    if not c.WalkLeft(2) then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not c.WalkUp() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor11()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 4 },
        { ['Up'] = 3 },
        { ['Left'] = 1 },
        { ['Up'] = 7 },
        { ['Right'] = 4 },
        { ['Down'] = 5 },
        { ['Right'] = 24 },
        { ['Down'] = 4 },
        { ['Right'] = 4 },
        { ['Up'] = 9 },
        { ['Left'] = 9 },
        { ['Up'] = 3 },
        { ['Left'] = 2 },
        { ['Up'] = 1 },
        { ['Left'] = 5 },
        { ['Down'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor12()
    if not c.WalkUp(2) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor13()
    if not c.WalkUp() then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not _stairs() then return false end
    if not c.WalkUp() then return false end
    if not _stairs() then return false end
    if not c.WalkUp() then return false end
    c.RandomFor(689)
    if not c.WalkUp(2) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_enterTower, 10)
    if c.Success(result) then
        local result = c.Best(_floor1, 10)
        if c.Success(result) then
            local result = c.Best(_floor2, 10)
            if c.Success(result) then
                local result = c.Best(_floor3, 10)
                if c.Success(result) then
                    local result = c.Best(_floor4, 10)
                    if c.Success(result) then
                        local result = c.Best(_floor5, 10)
                        if c.Success(result) then
                            local result = c.Best(_floor6, 10)
                            if c.Success(result) then
                                local result = c.Best(_floor7, 10)
                                if c.Success(result) then
                                    local result = c.Best(_floor8, 10)
                                    if c.Success(result) then
                                        local result = c.Best(_floor9, 10)
                                        if c.Success(result) then
                                            local result = c.Best(_floor10, 10)
                                            if c.Success(result) then
                                                local result = c.Best(_floor11, 10)
                                                if c.Success(result) then
                                                    local result = c.Best(_floor12, 10)
                                                    if c.Success(result) then
                                                        local result = c.Best(_floor13, 10)
                                                        if c.Success(result) then
                                                            return true
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
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
end

c.Finish()

