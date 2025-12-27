dofile('loz-core.lua')

--TODO: actual value, 106 is pretty close but not exact
function isFasterToMoveLeft(x)
    return x < 106
end

c.Start()
p = c.Player()

if (isFasterToMoveLeft(p.x)) then
    c.LeftUntil(0)
    c.PushLeft(58)
    c.UntilNextInputFrame()
    c.Done()
elseif p.x > 224 then
    c.LeftUntil(224)
end

while not c.IsDone() do
    p = c.Player()

    if (p.x ~= 235 and p.x ~= 0) then
        c.PushRight(1)
    elseif (p.x == 235) then
        c.PushUp()
        c.PushRight(2)
    elseif (p.x == 0) then
        c.PushLeft(58)
        c.UntilNextInputFrame()
        c.Done()
    end
end

c.Finish()

