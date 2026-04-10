-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 35 then
    error('must be run in level 35')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.LeftUntil(3)
    c.GrabLadderLeft()
    c.ClimbUntil(10)
    c.RightUntil(10)


    c.GrabLadderRight()
    c.ClimbUntil(8)
    c.LeftUntil(10)
    c.UntilDig('Left', 'B')
    c.WalkOverEnemy('Left')
    c.LeftUntil(3)
    c.GrabLadderLeft()
    c.ClimbUntil(6)
    c.RightUntil(5)
    c.UntilDig('Right', 'A')
    c.WalkOverEnemy('Right')
    c.RightUntil(10)
    c.GrabLadderRight()
    c.ClimbUntil(4)
    c.LeftUntil(3)
    c.GrabLadderLeft()
    c.ClimbUntil(2)
    c.RightUntil(9)
    c.UntilDig('Right', 'A')

    c.Assert(c.FrameSearch(function()
        while c.Enemy(2).levelY > 4 do
            c.WaitFor(1)
        end
        while c.Enemy(2).levelX > 11 do
            c.WaitFor(1)
        end

        local result = c.FallRight()
        if not result then return false end

        if c.Player().levelY ~= 4 then
            return false
        end

        result = c.RightFor(1)
        if not result then return false end

        return c.GrabLadderRight('Down')
    end))

    c.ClimbUntil(6)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.GrabLadderRight('Down')
    c.ClimbUntil(10)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.RightUntil(25)
    c.GrabLadderRight()

    c.ClimbUntil(10)
    c.LeftUntil(17)
    c.GrabLadderLeft()
    c.ClimbUntil(8)
    c.RightUntil(17)
    c.UntilDig('Right', 'A')
    c.Assert(c.WalkOverEnemy('Right'))
    c.RightUntil(25)
    c.GrabLadderRight()
    c.ClimbUntil(6)
    c.LeftUntil(17)
    c.GrabLadderLeft()

    c.ClimbUntil(4) -- Do this if gold is not exactly on the ladder
    --c.ClimbUntilGold('Right')

    c.RightUntil(17)
    c.GrabLadderRight()
    c.ClimbUntil(2)
    c.LeftUntil(17)
    c.GrabLadderLeft()
    c.ClimbUntilLevelEnd()

    -- c.Marker('lv 35 end')

    c.Done()
end

c.Finish()
