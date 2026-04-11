-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 36 then
    error('must be run in level 36')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilGoldRight()
    c.GrabLadderLeft()
    c.ClimbUntil(11)


    c.GrabAndClimbOneRight()
    c.GrabAndClimbOneLeft()

    c.Done()
end

c.Finish()
