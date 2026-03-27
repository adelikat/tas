dofile('lode-runner-core.lua')

c.Start()

while not c.IsDone() do
    c.Done()
end

c.Finish()
