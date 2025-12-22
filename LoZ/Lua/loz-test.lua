dofile('loz-core.lua')
client.unpause()
while not c.IsDone()  do
    c.PushRight(100)
    c.Done()

	emu.frameadvance();
end

c.Finish()
