-- Starts at the last lag frame after leaving Monbaraba to the overworld
-- Manipulates entering the cave west of Kievs
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _walkOneSquare(direction, cap)
    if c.Read(c.Addr.MoveTimer) ~= 0 then
        c.Log('Move timer must be zero to call this method!')
        return false
    end

    if cap == nil or cap <= 0 then
        cap = 100
    end
    
    c.Save('WalkStart')

    local attempts = 0
    while attempts < cap do
        c.Load('WalkStart')
        c.PushFor(direction, 1)
        if c.Read(c.Addr.MoveTimer) ~= 15 then
            return c.Bail('Move timer did not start on 15')
        end

        c.RandomFor(14)
        c.WaitFor(1)
        if c.IsEncounter() then
            attempts = attempts + 1
        else
            return true
        end
    end
    
    c.Debug('Could not avoid encounter')
    return false
end

local function _do()
    local result
    for i = 1, 13 do
        result = _walkOneSquare('Up')
        if not result then
            return false
        end
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    local result = c.Cap(_do, 100)
    if result then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
