--Starts at the first frame to dimiss the "terrific blow" message from Ragnar's max damage critical, manipulates until Burland appears
-- Manipulates Burland appearing
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
--c.BlackscreenMode()
c.Load(3)

local function _do()
    c.BattleAdvance()
    c.RandomAtLeastOne()
    c.RandomFor(1)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.BattleAdvance()
    c.RandomAtLeastOne()
    c.WaitFor(6)
    if not c.MinDmg(6) then return false end
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.BattleAdvance()
    c.RandomAtLeastOne()
    c.RandomFor(40)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.RandomAtLeastOne()
    c.RandomFor(30) -- Magic frame in here
    c.UntilNextInputFrame()
    c.AorBAdvance(3)
    return true
end

while not c.IsDone() do
    local result = c.Best(_do, 100)
    if c.Success(result) then
        c.Done()
    end

    c.RngCache:Log()
end
