dofile('loz-core.lua')

c.Start()
while not c.IsDone() do
    c.Done()
end

c.Finish()