dofile('loz-core.lua')
c.Start()
while not c.IsDone()  do
    c.PushRight(100)
    c.Done()

	emu.frameadvance();
end

c.Finish()
