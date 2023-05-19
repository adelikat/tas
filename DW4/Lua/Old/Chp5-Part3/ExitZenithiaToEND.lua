-- Starts at the last lag frame upon the map screen appearing in Zenithia before the Dragon
-- Manipulates to the end
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 0
local delay = 0
local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

-- Overriding because E1 Type does not get cleared so the core function thinks there is an encounter
c.WalkOneSquare = function(direction, cap)
    if c.Read(c.Addr.MoveTimer) ~= 0 then
        c.Log(string.format('Move timer must be zero to call this method! %s', c.Read(c.Addr.MoveTimer)))
        return false
    end

    if cap == nil or cap <= 0 then
        cap = 100
    end
    
    c.Save('WalkStart')

    local attempts = 0
    while attempts < cap do
		if attempts > 0 then
			c.Load('WalkStart')
		end
        
        c.PushFor(direction, 1)
        if c.Read(c.Addr.MoveTimer) == 0 then
            return c.Bail('Move timer did not increase')
        end        

        while c.Read(c.Addr.MoveTimer) > 1 do
            c.RandomForNoA(1)
        end
       
        c.WaitFor(1)
        -- if c.IsEncounter() then
        --     attempts = attempts + 1
        -- else
            return true
        --end
    end
    
    c.Debug('Could not avoid encounter')
    return false
end

local function _floor1()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.WalkDown(6) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor2()
    if not c.WalkDown(4) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor3()
    if not c.WalkDown(8) then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor4()
    local result = c.WalkMap({
        { ['Down'] = 6 },
        { ['Right'] = 13 },
        { ['Down'] = 6 },
        { ['Left'] = 3 },
        { ['Up'] = 2 }
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor5()
    local result = c.WalkMap({
        { ['Up'] = 2 },
        { ['Left'] = 17 },
        { ['Down'] = 4 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return true
end

local function _floor6()
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 2 },
        { ['Down'] = 11 },
    })
    if not result then return false end
    c.PushDown()
    return true
end

local function _do()
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
                        local result = c.Best(_floor6, 12)
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

    local result = c.Best(_do, 12)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()

