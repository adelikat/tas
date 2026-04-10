-- Starts on the frame immediately after pressing select to do the select skip
dofile('lode-runner-core.lua')

c.Start()

if c.CurrentLevel() ~= 43 then
    error('must be run in level 43')
end

if c.GameMode() ~= 1 then
    error('must be run in level mode')
end

while not c.IsDone() do
    c.Done()
end

c.Finish()
