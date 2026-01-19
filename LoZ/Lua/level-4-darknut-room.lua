--Start this script while in the corridor of the top door of the screen before the 6 darknut room, 2nd quest
--Manipulates the ideal enemy pattern of the 6 darknuts
dofile('loz-core.lua')

if c.Quest() ~= 2 then
    error('This script must be run on quest 2')
end

if c.Level() ~= 5 then -- note that level 4 is actually level 5 underneath the hood, but displays as level 4
    error('This script must be run on level 4')
end

if c.Screen() ~= 92 then
    error('This script must be run on the opening below the target screen')
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

function Evaluate1()
    c.Debug('running Evalulate 1')
    e1 = c.Enemy(1)
    e2 = c.Enemy(2)
    e3 = c.Enemy(3)
    e4 = c.Enemy(4)
    e5 = c.Enemy(5)
    e6 = c.Enemy(6)

    if e1.x ~= 128 or e1.y ~= 139 then
        c.Debug('failure at E1, expected 128,139 got ' .. e1.x .. ',' .. e1.y)
        return false
    end

    if e2.x ~= 144 or e2.y ~= 125 then
        c.Debug('failure at E2, expected 144,125 got ' .. e2.x .. ',' .. e2.y)
        return false
    end

    if e3.x ~= 160 or e3.y ~= 93 then
        c.Debug('failure at E3, expected 160,93 got ' .. e3.x .. ',' .. e3.y)
        return false
    end

    if e4.x ~= 160 or e4.y ~= 157 then
        c.Debug('failure at E4, expected 160,157 got ' .. e4.x .. ',' .. e4.y)
        return false
    end

    if e5.x ~= 192 or e5.y ~= 109 then
        c.Debug('failure at E5, expected 192,109 got ' .. e5.x .. ',' .. e5.y)
        return false
    end

    if e6.x ~= 48 or e6.y ~= 109 then
        c.Debug('failure at E6, expected 48,109 got ' .. e6.x .. ',' .. e6.y)
        return false
    end

    if e1.direction ~= c.Directions.Up then
        c.Debug('failure at E1, expected direction Up but got ' .. e1.direction)
        return false
    end

    if e2.direction ~= c.Directions.Down then
        c.Debug('failure at E2, expected direction Down but got ' .. e2.direction)
        return false
    end

    if e3.direction ~= c.Directions.Down then
        c.Debug('failure at E3, expected direction Down but got ' .. e3.direction)
        return false
    end

    if e4.direction ~= c.Directions.Down then
        c.Debug('failure at E4, expected direction Down but got ' .. e4.direction)
        return false
    end

    if e5.direction ~= c.Directions.Down then
        c.Debug('failure at E5, expected direction Down but got ' .. e5.direction)
        return false
    end

    if e6.direction ~= c.Directions.Down then
        c.Debug('failure at E6, expected direction Down but got ' .. e6.direction)
        return false
    end

    c.Save(4)
    c.Debug('successful evaluate')
    return true
end

function Evaluate2()
    c.Debug('running Evalulate 2')
    e1 = c.Enemy(1)
    e2 = c.Enemy(2)
    e3 = c.Enemy(3)
    e4 = c.Enemy(4)
    e5 = c.Enemy(5)
    e6 = c.Enemy(6)

    if e1.x ~= 128 or e1.y ~= 136 then
        c.Debug('failure at ' .. e1.num .. ' expected 128,136 got ' .. e1.x .. ',' .. e1.y)
        return false
    end

    if e2.x ~= 144 or e2.y ~= 129 then
        c.Debug('failure at E2, expected 144,129 got ' .. e2.x .. ',' .. e2.y)
        return false
    end

    if e3.x ~= 160 or e3.y ~= 96 then
        c.Debug('failure at E3, expected 160,96 got ' .. e3.x .. ',' .. e3.y)
        return false
    end

    if e4.x ~= 156 or e4.y ~= 157 then
        c.Debug('failure at E4, expected 156,57 got ' .. e4.x .. ',' .. e4.y)
        return false
    end

    if e5.x ~= 189 or e5.y ~= 109 then
        c.Debug('failure at E5, expected 189,109 got ' .. e5.x .. ',' .. e5.y)
        return false
    end

    if e6.x ~= 48 or e6.y ~= 110 then
        c.Debug('failure at E6, expected 48,110 got ' .. e5.x .. ',' .. e5.y)
        return false
    end

    c.Debug('successful evaluate')
    c.Save(5)
    return true
end


function Enter()
    local delay = 0
    c.Save('temp-start-enter')
    local success = false
    --TODO: bail out after x number of delay
    while not success do
        c.Load('temp-start-enter')
        c.Debug('enter, attempting with delay: ' .. delay)
        c.WaitFor(delay)
        UntilScrollStart()
        UntilScreenScrollDone()
        UpUntilY(167)
        local success = Evaluate1()
        console.log('success', success)
        if success then
            console.log('Enter success!')
            return true
        else
            delay = delay + 1
        end
    end

    return true
end

function Pause()
    local delay = 0
    c.Save('temp-start-pause')
    local success = false
    --TODO: bail out after x number of delay
    while not success do
        c.Load('temp-start-pause')
        c.Debug('pause, attempting with delay: ' .. delay)
        c.PushUpAndSelect()
        c.WaitFor(1 + delay)
        c.PushUpAndSelect()
        UpUntilY(159)
        local success = Evaluate2()
        if success then
            console.log('Pause success!')
            return true
        else
            delay = delay + 1
        end
    end

    return true
end

c.Start()
local delay = 0
c.Save('temp-start')
while not c.IsDone() do
    local enterSuccess = Enter()
    if (enterSuccess) then
        local pauseSuccess = Pause()
        if pauseSuccess then
            c.Done()
        end
    else
        console.log('fail')
    end
end

c.Finish()