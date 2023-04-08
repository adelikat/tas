-- Starts at the last lag frame after entering the Cave SouthEast of Gardenbur
-- Manipulates encountering Bakor
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000
c.maxDelay = 2

local function _tempSave(slot)
    c.Log('Saving ' .. slot)
    c.Save(slot)
end

local function _stairs(direction)
    if c.Read(c.Addr.MoveTimer) ~= 0 then
        error(string.format('Move timer must be zero to call this method! %s', c.Read(c.Addr.MoveTimer)))
        return false
    end
    local cap = 100
    
    c.Save('WalkStart')

    local attempts = 0
    while attempts < cap do
        c.Load('WalkStart')
        c.PushFor(direction, 1)
        if c.Read(c.Addr.MoveTimer) ~= 15 then
            return c.Bail('Move timer did not start on 15')
        end

        c.RandomFor(20)
        c.WaitFor(1)
        if c.IsEncounter() then
            attempts = attempts + 1
        else
			local moveTimer = c.Read(c.Addr.MoveTimer)
			if moveTimer == 1 then
				c.WaitFor(1) -- Accounts for lag during day/night transition
				c.Debug('Lagged, increasing walk by 1 frame')
			end
            return true
        end
    end
    
    c.Debug('Could not avoid encounter')
    return false
end

local function _floor1()
    local result = c.WalkDown()
    if not result then return false end
    if not _stairs('Down') then return false end
    result = c.WalkMap({
        { ['Down'] = 8 },
        { ['Left'] = 5 },
        { ['Up'] = 2 },
        { ['Left'] = 2 },
        { ['Up'] = 8 },
        { ['Left'] = 4 },
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    result = c.WalkMap({
        { ['Down'] = 8 },
        { ['Right'] = 1 },
        { ['Down'] = 1 },
        { ['Right'] = 2 },
        { ['Down'] = 2 },
        { ['Left'] = 6 },
        { ['Up'] = 15 },
        { ['Right'] = 4 },
        { ['Up'] = 3 },
        { ['Right'] = 20 },
        { ['Down'] = 16 },
        { ['Right'] = 6 },
        { ['Down'] = 5 },
        { ['Right'] = 3 }
    })
    if not result then return false end
    if not _stairs('Up') then return false end
    result = c.WalkMap({
        { ['Up'] = 8 },
        { ['Left'] = 5 },
        { ['Up'] = 9 },
        { ['Right'] = 10 },
        { ['Down'] = 22 }
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    if not c.WalkDown() then return false end
    if not _stairs('Down') then return false end
    result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 2 },
        { ['Down'] = 1 },
        { ['Left'] = 36 },
        { ['Up'] = 9 },
        { ['Right'] = 5 },
        { ['Down'] = 5 },
        { ['Right'] = 4 },
        { ['Up'] = 2 },
        { ['Right'] = 3 },
        { ['Up'] = 3 },        
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor2()
    local result = c.WalkMap({
        { ['Left'] = 1 },
        { ['Down'] = 2 },
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 3 },
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 9 },
        { ['Down'] = 15 },
        { ['Right'] = 4 },
    })
    if not result then return false end
    if not _stairs('Up') then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    if not _stairs('Up') then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Right'] = 7 },
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Right'] = 1 },
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    local result = c.WalkMap({
        { ['Down'] = 12 },
        { ['Right'] = 1 },
        { ['Down'] = 8 },
        { ['Left'] = 3 },
    })
    if not result then return false end
    if not _stairs('Up') then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 10 },
    })
    if not result then return false end
    if not _stairs('Up') then return false end
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 7 },
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    if not _stairs('Down') then return false end
    local result = c.WalkMap({
        { ['Down'] = 1 },
        { ['Left'] = 3 },
        { ['Up'] = 7 },
        { ['Right'] = 4 },
        { ['Up'] = 9 },
    })
    if not result then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    return not c.IsEncounter()
end

local function _floor3()
    local result = c.WalkMap({
        { ['Up'] = 1 },
        { ['Left'] = 5 },
        { ['Up'] = 3 },
        { ['Right'] = 1 },
        { ['Up'] = 5 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.WaitFor(10)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(40)
    c.UntilNextInputFrame()
    c.AorBAdvance()
    c.WaitFor(1)
    c.DismissDialog()
    c.RandomFor(80)
    local result = c.WalkMap({
        { ['Left'] = 2 },
        { ['Down'] = 3 },
        { ['Left'] = 2 },
    })
    if not result then return false end
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(10)
    c.UntilNextInputFrame()
    return true
end

c.Load(3)
c.Save(100)
c.RngCacheClear()
client.speedmode(3200)
client.unpause()
while not c.done do
	c.Load(100)
	local result = c.Best(_floor1, 20)
	if c.Success(result) then
        local result = c.Best(_floor2, 20)
        if c.Success(result) then
            local result = c.Best(_floor3, 12)
            if c.Success(result) then
		        c.Done()
            end
        end
	end
end

c.Finish()



