-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 12 then
    error('must be run in level 12')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

local function AvoidEnemyPickups()
    c.PushDown()
    c.FinishFalling()
    c.LeftFor(1)
    c.FallLeft()
    c.UntilGold('Right')
    return c.Enemy(1).timer >= 0 and c.Enemy(2).timer >= 0 and c.Enemy(3).timer >= 0
        and c.Enemy(1).levelY <= 10
end

local function End(amt)
    if not amt or amt < 2 then
        error('must be 2 or more')
    end

    c.LeftFor(amt)
    c.PushDown()
    if amt < 5 then
        c.LeftUntil(19)
        c.UntilGold('Left')
    end

    c.FallRight()
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.Climb(4)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()


    return true
end

local function End5()
    c.LeftFor(5)
    c.PushDown()
    c.FinishFalling()
    c.RightFor(1)

    c.FallRight()
    c.UntilLadderGrab('Right')
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.Climb(3)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.Climb(4)
    c.UntilGold('Right')
    c.UntilLadderGrab('Left')
    c.ClimbUntilLevelEnd()


    return true
end

while not c.IsDone() do
    c.UntilGold('Left')
    c.RightFor(5)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(9)
    c.UntilGold('Left')
    c.UntilLadderGrab('Left')

    c.ClimbUntil(7)
    c.UntilLadderGrab('Right')

    c.ClimbUntil(6)
    c.PushFor('Right', 3)

    c.ClimbUntil(5)
    c.UntilLadderGrab('Right')

    c.ClimbUntil(4)
    c.PushRight()
    c.UntilLadderGrab('Right')

    c.ClimbUntil(2)
    c.RightUntil(17)
    c.UntilLadderGrab('Right')
    c.ClimbUntil(1)
    c.LeftUntil(5)
    c.PushDown()
    c.FinishFalling()
    c.LeftFor(2)
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.RightFor(1)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.UntilDig('Right', 'B')
    c.FallLeft()
    c.UntilDig('Left', 'A')
    c.UntilGold('Left')
    c.FallRight()

    c.RightUntil(15)

    c.FrameSearch(AvoidEnemyPickups)
    c.UntilLadderGrab('Right')

    c.Climb(2)

    c.BestOf({
        function() return End(2) end,
        function() return End(3) end,
        function() return End(4) end,
        End5
    })

    c.Marker('lv 12 end')

    c.Done()
end

c.Finish()
