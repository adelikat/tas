--Starts at the first frame of the game, or any of the opening lag frames
--Manipulates until Glass Joe Round 1 starts
dofile('MTPO-Core.lua')

c.InitSession()
if c.Mode() ~= c.Modes.OpeningBlackScreen and emu.framecount() < 10 then
    error('This script must be run during the opening black screen')
end

c.FastMode()
c.BlackscreenMode()

local function _do()
    -- There is a not lag frame on frame 3
    while emu.framecount() < 50 do
        c.WaitFor(1)
    end
    c.UntilMode(c.Modes.MenuScreen)
    c.UntilNextInputFrame()
    c.PushStart(2)
    c.UntilMode(c.Modes.PreRound)
    c.UntilNextInputFrame()

    if c.CurrentOpponent() ~= opponents.GlassJoe then
        c.Log('Something went wrong! Did not arrive at Glass Joe')
        return false
    end

    if c.Round() ~= 1 then
        c.Log('Something went wrong! Not on Round 1')
        return false
    end

    c.PushStart(2)
    c.UntilMode(c.Modes.FightIsStarting)
    return true
end


while not c.IsDone() do
    local result = c.Cap(_do, 100)
    console.log('done: ' .. tostring(result)) 
    if c.Success(result) then
        console.log('success')
        c.Done()
    else
        console.log('fail')
    end
end
