local mode = movie.mode()

if mode ~= 'PLAY' then
    error('Movie needs to be in playback mode, current mode: ' .. mode)
end

client.unpause()

local done = false

local _rawBtnList = {
    ['P1 Up'] = false,
    ['P1 Down'] = false,
    ['P1 Left'] = false,
    ['P1 Right'] = false,
    ['P1 B'] = false,
    ['P1 A'] = false,
    ['P1 Select'] = false,
    ['P1 Start'] = false,
}

function getAllMemory()
    return mainmemory.read_bytes_as_array(0x0000, 0x07FF)
end

local function save(slot)
    if slot == nil then
        error("slot can not be nil")
    end

    slotNum = tonumber(slot)
    if slotNum == 0 then
        slotNum = 10
    end

    if slotNum ~= nill and slotNum > 0 and slotNum <= 10 then
        local orig = _config.Savestates.SaveScreenshot
        _config.Savestates.SaveScreenshot = true
        savestate.saveslot(slot)
        console.log('Saved to slot ' .. slot)
        _config.Savestates.SaveScreenshot = orig
    else
        savestate.save(string.format('state-archive/%s.State', slot))
    end
end

local function getPressedBtns(btns)
    local pressed = {}

    for k, v in pairs(btns or {}) do
        -- Some input tables use string "True"/"False" values (from bizhawk), others may use boolean values.
        if v == "True" or v == true then
            pressed[k] = v
        end
    end

    return pressed
end

local function areArraysTheSame(arr1, arr2)
    if #arr1 ~= #arr2 then
        return false
    end

    for k, v in pairs(arr1) do
        if arr2[k] ~= v then
            return false
        end
    end

    return true
end

local function minimizeBtnSet(btns, frame)
    save('minimize-start-' .. frame)
    console.log('getting memory for frame ' .. frame)
    local newBtns = _rawBtnList;
    local origMemory = getAllMemory()
    for k, v in pairs(btns) do
        newBtns[k] = false
        console.log('turning off ' .. k .. ' new btns', newBtns)

        client.unpause()
        emu.frameadvance()
        client.pause()
        console.log('now getting getting memory for next frame ' .. emu.framecount())
        local newMemory = getAllMemory()
        local result = areArraysTheSame(origMemory, newMemory)

        console.log('memory is the same', result)
    end
end

while not done do
    local frame = emu.framecount()
    local btns = movie.getinput(frame)
    local pressed = getPressedBtns(btns)
    minimizeBtnSet(pressed, frame)
    console.log('btns', btns)
    console.log('pressed', pressed)

    emu.frameadvance()
    done = true
end

client.pause()
console.log('------------')
console.log('success')
