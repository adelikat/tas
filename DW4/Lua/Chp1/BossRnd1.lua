-- Starts from the magic frame
-- Manipulates equipping the sowrd of malice, getting 2 misses, and a critical hit on the eyeball
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(2)

local function _turn()
    c.RandomFor(2)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    return true
end

while not c.IsDone() do
    local result = c.Best(_do, 4)
    if c.Success(result) then
        c.Done()
    end    
end