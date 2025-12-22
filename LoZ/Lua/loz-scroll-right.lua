dofile('loz-core.lua')

function isFasterToMoveRight(x)
    return x >= 106
end

client.unpause()
p = c.Player()

if (isFasterToMoveRight(p.x)) then
    c.RightUntil(240)
    c.PushRight(58)
    c.UntilNextInputFrame()
    c.Done()
elseif p.x < 16 then
    c.RightUntil(16)
end

while not c.IsDone() do
    p = c.Player()

    if (p.x ~= 5 and p.x ~= 240) then
        c.PushLeft()
    elseif p.x == 5 then
        c.PushUp()
        c.PushLeft(2)
    elseif p.x == 240 then
        c.PushRight(58)
        c.UntilNextInputFrame()
        c.Done()
    end
end

c.Finish()

