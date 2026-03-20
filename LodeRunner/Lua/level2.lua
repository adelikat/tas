-- Starts in the lag frames before the level appears
dofile('lode-runner-core.lua')

c.Start()


if c.CurrentLevel() ~= 2 then
    error('must be run in level 2')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.UntilLadderGrab('Left')
    c.Climb(2)
    c.Done()
end

c.Finish()
