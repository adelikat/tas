--Starts at the last lag frame after entering Izmut at night for the first time
--Manipulates talking to the kid, leaving and getting in an optimal death warp encounter
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
c.BlackscreenMode()
c.Load(1)

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

local function _part1()
    if not c.WalkUp(6) then return false end
    c.PushLeft()

    local kidX = addr.Npc1XSquare:Read()
    if kidX ~= 4 then return false end
    local kidY = addr.Npc1YSquare:Read()
    if kidY ~= 14 then return false end

    
    return true
end

local function _part2()
    c.RandomWithoutA(14)
    c.WaitFor(1)
    if not c.WalkLeft(5) then return false end
    c.PushLeft()
    c.PushA()
    c.RandomFor(10)

    local kidX = addr.Npc1XSquare:Read()
    if kidX ~= 6 then return false end
    local kidY = addr.Npc1YSquare:Read()
    if kidY ~= 18 then return false end

    return true
end

local function _toKid()
    if not _part1() then return false end    
    c.Log('Kid position partial success')
    c.RngCache:Add()
    if not c.Cap(_part2, 100) then
        return false
    end

   return true
end

while not c.IsDone() do
    local result = c.Cap(_toKid, 100)
    if c.Success(result) then
        c.Done()
    end

    c.RngCache:Log()
end

