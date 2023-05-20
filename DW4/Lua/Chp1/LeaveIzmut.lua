--Starts right before talking to the kid at night in Izmut
--Specifally the move timer must be 4, with the kid directly above at x,y = 6,19
--Manipulates talking to the kid, leaving and getting in an optimal death warp encounter
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(2)
local _demonStump = 0x0C
--Cuts out encounter and daynight stuff to make it faster
c.WalkOneSquare = function(direction, cap)
    if addr.MoveTimer:Read() ~= 0 then
        c.Log(string.format('Move timer must be zero to call this method! %s', c.Read(c.Addr.MoveTimer)))
        return false
    end

    if cap == nil or cap <= 0 then
        cap = 100
    end

    c.Push(direction)
    c.RandomWithoutA(14)
    c.WaitFor(1)
        
    if addr.MoveTimer:Read() ~= 0 then
        c.Log('Move timer is an unexpected value')
        return false
    end        

    return true
end

local function _leave()
    c.RandomFor(3)
    c.WaitFor(1)
    c.PushUp()
    if not c.BringUpMenu() then return false end
    if not c.PushAWithCheck() then return false end
    c.RandomFor(3)
    c.UntilNextInputFrameThenOne()
    c.WaitFor(1)
    c.DismissDialog()
    if not c.ChargeUpWalking() then return false end
    if not c.WalkLeft(7) then return false end
    c.UntilNextInputFrame()
    return true
end

local function _encounter()
    local direction = c.GenerateRndDirection()
    c.Walk(direction)
    c.WaitFor(10)
    if not c.IsEncounter() then
        return false
    end

    if addr.EGroup2Type:Read() ~= 0xFF then
        return false
    end

    if addr.E1Count:Read() ~= 1 then
        return false
    end

    if addr.EGroup1Type:Read() ~= _demonStump then
        return false
    end

    c.UntilNextInputFrame()
    return true
end

local function _do()
    local result = c.Best(_leave, 12)
    if c.Success(result) then
        c.RngCache:Add()
        result = c.Cap(_encounter, 250)
        if c.Success(result) then
            return true
        end
    end

    return false
end

while not c.IsDone() do
    local result = c.Cap(_do, 100)
    if c.Success(result) then
        c.Done()
    end

    c.RngCache:Log()
end

