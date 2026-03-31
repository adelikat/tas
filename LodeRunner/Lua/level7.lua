-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 7 then
    error('must be run in level 7')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end


local function ClimbAndDigLeft()
    local result = c.ClimbUntil(3)
    if not result then return false end
    result = c.LeftFor(2)
    if not result then return false end
    result = c.UntilDig('Left', 'B')
    if not result then return false end
    return c.FallLeft()
end

local function LeftFor2()
    local result = c.LeftUntil(9)
    if not result then return false end
    local p = c.Player()
    return p.yPos() < 8 and p.isAlive
end

while not c.IsDone() do
    c.RightUntil(18)
    c.UntilDig('Right', 'A')
    c.FrameSearch(c.GrabLadderRight)
    c.ClimbUntil(10)
    c.PushUp()

    c.FrameSearch(function() return c.ClimbUntil(6) end, 25)
    c.ClimbUntil(1)
    c.RightFor(5)
    c.PushDown()
    c.FinishFalling()

    c.LeftFor(2)
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.GrabLadderLeft()

    c.ClimbUntil(7)

    c.FrameSearch(ClimbAndDigLeft)

    c.GrabLadderLeft()
    c.ClimbUntil(7)

    c.LeftFor(3)

    -- Must get good  enough spawn, 11 thru 19
    c.LeftFor(1)
    c.WaitFor(5) -- At least we have 5 frames of leeway

    c.UntilDig('Left', 'B')
    c.WaitFor(5)
    c.FrameSearch(LeftFor2)
    c.LeftUntil(4)

    -- GrabLadderLeft misses the gold
    -- But until gold gets it but runs past the ladder
    -- since there is no lag here this should be consistent
    c.PushFor('Left', 4)
    c.PushBtnsFor({'Left', 'Down'})

    c.ClimbUntil(9)
    c.FallRight()
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(7)
    c.GrabLadderRight()
    c.ClimbUntil(5)
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.LeftFor(1)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 7 end')

    c.Done()
end

c.Finish()
