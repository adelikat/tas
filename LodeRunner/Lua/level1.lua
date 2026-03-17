-- Starts in the lag frames before the level appears
dofile('lode-runner-core.lua')

if tastudio.engaged() then
    -- put the marker anywhere in the lag frames before the level appears
    local frame = tastudio.find_marker_on_or_before(emu.framecount())
    c.GoToFrame(frame)
end


if c.CurrentLevel() ~= 1 then
    error('must be run in level 1')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

if c.GraphicsMode() ~= 0 then
    error('must be run before the level appears on the screen')
end

c.Start()

while not c.IsDone() do
    c.UntilLevelAppears()
    c.Done()
end

c.Finish()
