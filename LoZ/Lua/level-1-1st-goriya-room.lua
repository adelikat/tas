--Start this script while in the corridor of the top door of the 1st screen of Level 1, 2nd quest
--Manipulates the ideal enemy pattern of the 3 goriyas
dofile('loz-core.lua')

if c.Quest() ~= 2 then
    error('This script must be run on quest 2')
end

if c.Level() ~= 1 then
    error('This script must be run on level 1')
end

if c.Screen() ~= 119 then
    error('This script must be run on the opening screen of level 1')
end

if c.Player().x ~= 120 then
    error('Link must be at x position 120 to be in the corridor')
end

function UntilScrollStart()
    while c.GameMode() == c.GameModes.Normal do
        c.PushUp()
    end
end

function UntilScreenScrollDone()
    while c.GameMode() ~= c.GameModes.Normal do
        c.PushUp()
    end
end

function UpUntilY(y)
    while c.Player().y > y do
        c.PushUp()
    end
end

function Evaluate()
    e1 = c.Enemy(1)
    e2 = c.Enemy(2)
    e3 = c.Enemy(3)
    if e1.x ~= 0x58 then
        return false
    end

    if e2.x ~= 0x50 then
        return false
    end

    if e3.x ~= 0x58 then
        return false
    end

    if e1.y ~= 0x5D then
        return false
    end

    if e2.y ~= 0x95 then
        return false
    end

    if e3.y ~= 0x7D then
        return false
    end
console.log('e3: ' .. e3.x .. ',' .. e3.y)
    return true
end


c.Start()
local delay = 0
c.Save('temp-start')
while not c.IsDone() do
    c.Load('temp-start')
    console.log('attempting with delay: ' .. delay)
    c.WaitFor(delay)
    UntilScrollStart()
    UntilScreenScrollDone()
    UpUntilY(164)
    local success = Evaluate()
    console.log('success: ' .. tostring(success))
    if success then
        console.log('sucessful attempt')
        c.Done()
    end

    delay = delay + 1

end

c.Finish()