-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 17 then
    error('must be run in level 17')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    -- c.FallLeft()
    -- c.GrabLadderLeft()
    -- c.ClimbUntil(1)
    -- c.FallRight()
    -- c.RightFor(1)
    -- c.UntilDig('Right', 'B')
    -- c.FallLeft()
    -- c.LeftFor(1)
    -- c.FallLeft()
    -- c.GrabLadderLeft()
    -- c.ClimbUntil(1)
    -- c.RightUntil(3)

    -- c.WaitFor(8)
    -- c.WalkOverEnemy('Right')

    -- c.RightUntil(8)
    -- c.UntilDig('Right', 'A')

    -- c.Marker('temp')

    c.UntilDig('Left', 'A')

    -- c.UntilDig('Left', 'A')
    -- c.FallRight()
    -- c.RightFor(1)
    -- c.UntilDig('Right', 'A')
    -- c.UntilDig('Left', 'A')
    -- c.FallRight()
    -- c.UntilDig('Right', 'B')
    -- c.FallLeft()

    -- c.FallLeft()
    -- c.UntilDig('Left', 'A')
    -- c.FallRight()
    -- c.GrabLadderRight()
    -- c.ClimbUntil(11)
    -- c.UntilGoldRight()
    -- c.UntilDig('Left', 'A')

    -- c.WalkOverEnemy('Right')
    -- c.ClimbUntil(8)
    -- c.GrabLadderLeft()
    -- c.ClimbUntil(4)

    -- c.BestOf({
    --     function()
    --         c.RightUntil(17)
    --         c.PushDown()
    --         c.FinishFalling()
    --         return c.UntilDig('Left', 'B')
    --     end,
    --     function()
    --         c.RightFor(2)
    --         c.PushDown()
    --         c.FinishFalling()
    --         c.UntilGoldRight()
    --         return c.UntilDig('Left', 'B')
    --     end,
    -- })

    -- c.FallLeft()
    -- c.ClimbUntil(11)
    -- c.UntilDig('Right', 'A')
    -- c.FallRight()
    -- c.GrabLadderRight()

    -- c.ClimbUntil(11)
    -- c.RightUntil(22)
    -- c.UntilDig('Right', 'A')
    -- c.WalkOverEnemy('Right')
    -- c.GrabLadderRight()
    -- c.ClimbUntil(5)
    -- c.LeftFor(1)
    -- c.UntilDig('Left', 'B')
    -- c.UntilDig('Right', 'B')
    -- c.FallLeft()
    -- c.UntilDig('Left', 'B')
    -- c.FallLeft()
    -- c.UntilGoldLeft()
    -- c.UntilDig('Right', 'B')
    -- c.FallLeft()
    -- c.GrabLadderRight()

    -- c.ClimbUntil(10)

    -- c.Assert(c.FrameSearch(function()
    --     local result = c.ClimbUntil(8)
    --         if not result then return false end
    --         c.PushFor('Up', 2)

    --         local result = c.Player().isAlive
    --         if result and c.Player().yPos() ~= 8 then
    --             error('this search was only tested on yPos of exactly 8')
    --         end
    --         return result
    --     end
    -- ))

    -- c.Assert(c.FrameSearch(function() return c.ClimbUntil(2) end))
    -- c.ClimbUntilLevelEnd()

    -- c.Marker('lv 17 end')

    c.Done()
end

c.Finish()
