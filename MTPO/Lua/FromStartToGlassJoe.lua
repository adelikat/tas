--Starts at the first frame of the game, or any of the opening lag frames
--Manipulates until Glass Joe Round 1 starts
dofile('MTPO-Core.lua')

c.InitSession()


c.FastMode()
if c.Mode() ~= c.Modes.OpeningBlackScreen and emu.framecount() < 10 then
    error('This script must be run during the opening black screen')
end

while not c.IsDone() do
    -- There is a not lag frame on frame 3
    while emu.framecount() < 50 do
        c.WaitFor(1)
    end
    c.UntilNextInputFrame()
    c.UntilMode(c.Modes.MenuScreen)
    c.WaitFor(2)
    c.UntilNextInputFrame()
    c.PushStart(2)
    c.UntilMode(c.Modes.PreRound)
    c.UntilNextInputFrame()

    if c.CurrentOpponent() ~= c.OpponentNames.GlassJoe then
        c.Log('Something went wrong! Did not arrive at Glass Joe')
        return false
    end

    if c.CurrentRound() ~= 1 then
        c.Log('Something went wrong! Not on Round 1')
        return false
    end

    c.UntilNextInputFrame()
    c.PushStart(2)
    c.UntilMode(c.Modes.FightIsStarting)
    c.WaitFor(1) -- We want to actually be in this mode for the next scipt
    c.Done()
end

c.Finish()
