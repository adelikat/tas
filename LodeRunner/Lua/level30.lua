-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 30 then
    error('must be run in level 30')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.Assert(c.BestSearch(function()
        if not c.Player().isAlive then
            return false
        end
        local result = c.RightUntil(24)
        if not result then return false end
        c.PushDown()
        c.FinishFalling()
        c.FallLeft()
        c.UntilDig('Right', 'A')
        c.FallRight()
        c.LeftUntil(10)
        c.UntilDig('Left', 'B')
        c.FallLeft()
        c.LeftUntil(1)
        c.UntilGoldLeft()
        c.UntilGoldLeft()
        result = c.RightUntil(8)
        if not result then return false end

        result = c.FrameSearch(function()
            if not c.Player().isAlive then
                return false
            end

            local result = c.UntilDig('Right', 'A')
            if not result then return false end
            result = c.WalkOverEnemy('Right')
            if not result then return false end
            result = c.RightUntil(22)
            if not result then return false end

            local e1X = c.Enemy(1).levelX
            console.log(string.format('%s e1 spawn: %s', emu.framecount(), e1X))
            return e1X >= 22
        end, 31)

        if not result then return false end

        c.GrabLadderRight()
        c.ClimbUntil(11)
        c.FallRight()
        c.GrabLadderRight()
        c.ClimbUntil(1)
        c.LeftUntil(18)
        c.UntilDig('Left', 'B')
        c.FallLeft()
        c.LeftUntil(15)
        c.UntilDig('Left', 'B')
        c.FallLeft()

        return true
    end, 30))

    c.RightUntil(21)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(11)
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntil(1)
    c.LeftUntil(5)
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightUntil(10)
    c.UntilDig('Left', 'B')
    c.FallLeft()
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.RightUntil(22)
    c.GrabLadderRight()
    c.ClimbUntil(11)
    c.FallRight()
    c.GrabLadderRight()
    c.ClimbUntilLevelEnd()

    c.Marker('lv 30 end')

    c.Done()
end

c.Finish()
