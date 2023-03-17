-- Starts at the last lag frame after leaving Monbaraba to the overworld
-- Manipulates entering the cave west of Kievs
local c = require("DW4-ManipCore")
c.InitSession()
c.reportFrequency = 1000

local function _walkCloseToCave()
    local result = c.WalkUp(13)
    if not result then return false end

    result = c.WalkLeft(4)
    if not result then return false end

    result = c.WalkUp(32)
    if not result then return false end

    result = c.WalkLeft(3)
    if not result then return false end

    result = c.WalkUp(1)
    if not result then return false end

    result = c.WalkLeft(2)
    if not result then return false end

     result = c.WalkUp(3)
    if not result then return false end

    result = c.WalkLeft(6)
    if not result then return false end

    result = c.WalkDown()    
    if not result then return false end

    result = c.WalkLeft(2)
    if not result then return false end

    result = c.WalkDown(2)
    if not result then return false end

    result = c.WalkLeft(2)
    if not result then return false end

    result = c.WalkDown(2)
    if not result then return false end

    return true
end

local function _enterCave()
    c.WalkLeft(6)
    c.WaitFor(1)
    c.UntilNextInputFrame()

    return true
end

local function _do()
    local result = c.Cap(_walkCloseToCave, 100)
    if result then
        return c.Best(_enterCave, 40)
    end

    return true
end

c.Load(0)
c.Save(100)
c.RngCacheClear()
while not c.done do
	c.Load(100)

    local result = c.Best(_do, 2)
    if result > 0 then
        c.Done()
    else
        c.Log('No best result')
    end
end

c.Finish()
