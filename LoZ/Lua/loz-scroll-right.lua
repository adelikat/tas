local _done = false;
local _success = false;

local Directions = {
    Right = 1,
    Left = 2,
    Down = 4,
    Up = 8,
}

local GameModes = {
    Transition = 0,
    SelectionScreen = 1,
    FinishScroll = 4,
    Normal = 5,
    PrepareScroll = 6,
    Scrolling = 7,
    Cave = 0x0B,
    Registration = 0xE,
    Elimination = 0xF,
}

function pushRight()
    joypad.set({
		['P1 Up'] = false,
		['P1 Down'] = false,
		['P1 Left'] = false,
		['P1 Right'] = true,
		['P1 B'] = false,
		['P1 A'] = false,
		['P1 Select'] = false,
		['P1 Start'] = false
	})
end

function pushLeft()
    joypad.set({
		['P1 Up'] = false,
		['P1 Down'] = false,
		['P1 Left'] = true,
		['P1 Right'] = false,
		['P1 B'] = false,
		['P1 A'] = false,
		['P1 Select'] = false,
		['P1 Start'] = false
	})
end

function pushUp()
    joypad.set({
		['P1 Up'] = true,
		['P1 Down'] = false,
		['P1 Left'] = false,
		['P1 Right'] = false,
		['P1 B'] = false,
		['P1 A'] = false,
		['P1 Select'] = false,
		['P1 Start'] = false
	})
end



function scrollRightAfterWrap()
    for i = 1, 58 do
        pushRight()
        emu.frameadvance()
    end

    mode = memory.readbyte(0x0012)
    while mode ~= GameModes.Normal do
        mode = memory.readbyte(0x0012)
        console.log('mode: ' .. mode)
        emu.frameadvance()
    end
end

function moveRightEnoughToGoLeft()
    x = memory.readbyte(0x0070)
    while x < 16 do
        x = memory.readbyte(0x0070)
        pushRight()
        emu.frameadvance()
    end
end

client.unpause()
if x < 16 then
    moveRightEnoughToGoLeft()
end

--TODO: 115 is close but did not test numbers between 100 and 115
function isFasterToMoveRight(x)
    return x >= 115
end

function walkRight()
    x = memory.readbyte(0x0070)
    while x < 240 do
        x = memory.readbyte(0x0070)
        pushRight()
        emu.frameadvance()
    end
end

if (isFasterToMoveRight(x)) then
    walkRight()
    scrollRightAfterWrap()
    _done = true
    _success = true
end

while not _done do
    x = memory.readbyte(0x0070)
    direction = memory.readbyte(0x0098)

    -- TODO: if link is far enough to the right, just go right


    if (x ~= 5 and x ~= 240) then
        pushLeft()
    elseif (x == 5 and direction == Directions.Left) then
        pushUp()
        emu.frameadvance()
        pushLeft()
        emu.frameadvance()
        pushLeft()
    elseif (x == 240) then
        console.log('x 240')
        scrollRightAfterWrap()
        _done = true
        _success = true
    end

	emu.frameadvance();
end

if _success then
    client.pause()
    savestate.saveslot(8)
    console.log('success!')
end
