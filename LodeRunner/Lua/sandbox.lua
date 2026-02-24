dofile('lode-runner-core.lua')

c.Start()

while not c.IsDone() do
    --c.LeftUntil(5)
    --c.RightUntil(24)
    c.RightUntilLadderGrab()
    c.Done()
end

c.Finish()
