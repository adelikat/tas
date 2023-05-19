--Starts at the last lag frame after entering Izmut at night for the first time
--Manipulates talking to the kid, leaving and getting in an optimal death warp encounter
dofile('../DW4Core.lua')
c.InitSession()
c.FastMode()
--c.BlackscreenMode()
c.Load(1)

local function _toKid()
    if not c.WalkUp(6) then return false end
    if not c.WalkLeft(6) then return false end
    c.PushLeft()
    c.PushA()
    c.RandomFor(10)

    local kidX = addr.Npc1XSquare:Read()
    if kidX ~= 6 then return false end
    local kidY = addr.Npc1YSquare:Read()
    if kidY ~= 18 then return false end

    return true
end

while not c.IsDone() do
    local result = c.Cap(_toKid, 100)
    if c.Success(result) then
        c.Done()
    end
end

c.Finish()
