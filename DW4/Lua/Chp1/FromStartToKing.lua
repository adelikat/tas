--Starts anytime during the opening lag frames after boot, and manipulates to the last lag frame after the king's chamber's appear
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(1)

local function _do()
    c.UntilNextInputFrame()
    c.RandomAtLeastOne()
    c.UntilNextInputFrame()
    c.RandomWithoutA()
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomWithoutA()
    c.UntilNextInputFrame()
    c.PushA()
    c.RandomFor(3)
    c.WaitFor(3)
    c.UntilNextInputFrame()
    c.PushA()
    for i = 1, 6 do
        c.PushRight()
        c.PushDown()
    end
    c.WaitFor(1)
    c.PushRight()
    c.PushA()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushA() -- Male
    c.WaitFor(2)
    c.UntilNextInputFrame()
    for i = 1, 6 do
        c.PushRight()
        c.WaitFor(1)
    end
    c.PushRight()
    c.PushA()
    c.WaitFor(2)
    c.UntilNextInputFrameThenOne()
    c.RandomAtLeastOne()
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.RandomFor(2)
    c.UntilNextInputFrame()
    c.AorBAdvance(3)

    return true
end

while not c.IsDone() do
    local result = c.Best(_do, 20)
    if c.Success(result) then
        c.Done()
    end
end
