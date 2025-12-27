dofile('loz-core.lua')

c.Start()

while not c.IsDone() do
    if emu.islagged() then
        c.UntilNextInputFrame()
        c.WaitFor(1)
        c.Save(9)
    end
    c.UntilNextLagFrame()
    c.WaitFor(1)
    c.Done()
end

c.Finish()

