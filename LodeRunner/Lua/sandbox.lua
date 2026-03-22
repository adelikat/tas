-- Start at the end of a level, where pressing up for 1 frame will end the level
dofile('lode-runner-core.lua')

c.Start()

while not c.IsDone() do
    c.WaitFor(5)
    c.UntilLag({'Up'});
    c.UntilNextInputFrame()
    c.Done()
end

c.Finish()
