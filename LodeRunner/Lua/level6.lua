-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 6 then
    error('must be run in level 6')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

local function DodgeEnemiesBeforeBigDig()
    c.ClimbUntil(9)
    c.UntilGold('Left')
    c.UntilGold('Left')
    c.GrabLadderRight()
    c.ClimbUntilGold('Left')

    c.LeftFor(4)
    local result = c.UntilDig('Left', 'B')
    if not result then return false end

    result = c.UntilDig('Right', 'B')
    if not result then return false end

    result = c.UntilDig('Right', 'B')
    if not result then return false end

    c.FallLeft()
    c.LeftFor(1)

    result = c.UntilDig('Left', 'B')
    if not result then return false end

    result = c.UntilDig('Right', 'B')
    if not result then return false end

    result = c.UntilDig('Left', 'B')
    if not result then return false end

    result = c.UntilDig('Left', 'A')
    if not result then return false end

    c.FallRight()

    return c.Player().isAlive
end

local function FinalSection()
    local result = c.UntilDig('Right', 'A')
    if not result then return false end

    local result = c.FrameSearch(function() return c.RightFor(3) end)
    if not result then
        error('did not dodge the enemy')
        return false
    end

    c.GrabLadderRight()

    c.ClimbUntil(2)
    c.UntilDig('Up', 'B')
    c.UntilDig('Down', 'B')
    c.UntilDig('Down', 'B')

    c.BestOf({
        function()
            c.UntilGold('Left')
            return c.GrabLadderRight()
        end,
        function()
            c.ClimbUntil(4)
            c.UntilGold('Left')
            return c.GrabLadderRight()
        end,
    })

    c.ClimbUntil(2)
    c.ClimbUntilLevelEnd()
    return true
end

local function FinalDigSequences()
    c.RightUntil(17)
    c.UntilDig('Right', 'A')
    c.UntilDig('Left', 'A')
    c.UntilDig('Right', 'A')
    c.FallRight()
    c.UntilGoldLeft()
    c.UntilDig('Left', 'A')
    c.FallRight()
    c.GrabLadderRight('Down')
    c.ClimbUntil(7)

    c.WaitFor(7)
    c.Assert(c.FrameSearch(DodgeEnemiesBeforeBigDig))

    c.UntilGold('Left')
    c.RightUntil(21)
    return true
end

-- TODO: this depends on the spawn timer for a gold drop, validate the correct range of values
-- Note: getting the gold rather than letting the enemy drop it, is the same number of steps
-- Logic would make you think that this would be equal and less timing dependent, but it is actually slower
-- The enemy patters are very slightly different and causes significant lag differences
while not c.IsDone() do
    c.RightFor(1)
    c.UntilDig('Right', 'B')
    c.UntilDig('Right', 'B')
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')
    c.UntilDig('Left', 'B')
    c.UntilDig('Right', 'B')

    c.BestOf({
        function()
            return c.UntilGold('Left')
        end,
        function()
            c.ClimbUntil(12)
            return c.UntilGold('Left')
        end
    })

    c.GrabLadderRight()
    c.RightUntil(12)
    c.ClimbUntil(9)
    c.GrabLadderRight()
    c.ClimbUntilGold('Left')

    c.GrabLadderLeft()

    c.ClimbUntil(2)
    c.GrabLadderLeft()
    c.UntilDig('Up', 'B')

    c.BestOf({
        function()
            c.UntilDig('Left', 'A')
            c.UntilGold('Left')
            return c.FallRight()
        end,
        function()
            c.UntilDig('Left', 'A')
            c.UntilGold('Left')
            return c.FallRight()
        end,
    })

    c.GrabLadderRight()
    c.ClimbUntil(10)

    c.Assert(c.FrameSearch(function()
        c.ClimbUntil(9)
        c.RightUntil(8)
        c.ClimbUntil(6)
        local result = c.GrabLadderRight()
        if not result then return false end
        return c.ClimbUntil(3)
    end))

    c.ClimbUntilGold('Left')
    c.LeftUntil(5)
    c.ClimbUntil(1)
    c.RightUntil(16)

    c.BestSearch(FinalDigSequences, 8)

    c.BestSearch(FinalSection, 3)

    c.Marker('lv 6 end')

    c.Done()
end

c.Finish()
