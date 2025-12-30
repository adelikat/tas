dofile('loz-core.lua')

c.Start()
origMode = c.GameMode()

while not c.IsDone() do
    currMode = c.GameMode()

    while currMode == origMode do
        c.PushRight()
        currMode = c.GameMode()
    end

	c.UntilNextLagFrame()
    c.WaitFor(1)
    console.log('until next lag finished')
    c.Done()
end

c.Finish()