local mode = movie.mode()

if mode ~= 'PLAY' then
    error('Movie needs to be in playback mode, current mode: ' .. mode)
end

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

local function saveS(slot)
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

 function loadS(slot)
    if slot == nil then
        error("slot must be a number")
    end

    slotNum = tonumber(slot)

    if slotNum == 0 then
        slotNum = 10
    end

    if slotNum ~= nil and slotNum > 0 and slotNum <= 10 then
        savestate.loadslot(slotNum)
    else
        savestate.load(string.format('state-archive/%s.State', slot))
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
    for k, v in pairs(arr1) do
        --console.log('comparing ' .. string.format("%02X", v) .. ' to ' .. string.format("%02X", arr2[k])))
        if arr2[k] ~= v then
            console.log('difference found in byte ' .. k .. ': ' .. string.format("%02X", v) .. ' vs ' .. string.format("%02X", arr2[k]))
            return false
        end
    end

    return true
end

local function advance(numFrames)
    client.unpause()
    for i = 1, numFrames do
        emu.frameadvance()
    end
    client.pause()
end

local function isAnyBtnPressed(btns)
    for k, v in pairs(btns) do
        if v == "True" or v == true then
            return true
        end
    end

    return false
end

local function writeArrayToFile(arr, filename)
    local file = io.open(filename, "w")
    for k, v in pairs(arr) do
        file:write(string.format("%02X\n", v))
    end
    file:close()
end

local function minimizeBtnSet(btns, frame)
    local saveStateName = 'minimize-start-' .. frame
    if not isAnyBtnPressed(btns) then
        console.log('no buttons pressed for frame ' .. frame)
        return
    end

    console.log('minimizing btns for frame ' .. frame)

    saveS(saveStateName)
    advance(10)
    local syncedMemory = getAllMemory()
    writeArrayToFile(syncedMemory, 'memory-' .. frame .. 'before-minimize.txt')

    loadS(saveStateName)

    local keepBtns = _rawBtnList;

    for k, v in pairs(btns) do
        console.log('turning off ' .. k)
        local tryBtns = btns;
        tryBtns[k] = false
        joypad.set(tryBtns)
        client.unpause()
        emu.frameadvance()
        client.pause()
        advance(10)
        local newMemory = getAllMemory()
        writeArrayToFile(newMemory, 'memory-' .. frame .. 'after-minimize.txt')
        local result = areArraysTheSame(syncedMemory, newMemory)
        if (result) then
            console.log('Sync Success! keeping ' .. k .. ' off')
            keepBtns[k] = false
        else
            console.log('desync, reverting ' .. k)
            keepBtns[k] = true
        end

        loadS(saveStateName)
    end

    return keepBtns;
end

local function getAllMovieInputs()
    local numFrames = movie.length()
    local inputs = {}

    for i = 0, numFrames - 1 do
        inputs[i] = movie.getinput(i)
    end

    return inputs
end

local done = false
local origInputs = getAllMovieInputs()
local totalFrames = #origInputs

movie.setreadonly(false)
saveS('pre-minimize')
loadS('pre-minimize')
--client.unpause()
client.speedmode(1600)
while not done do
    local frame = emu.framecount()
    local inputsToRecord = origInputs[frame]
    if inputsToRecord == nil then
        error('got nil for inputs for frame ' .. frame)
    end

    local pressed = getPressedBtns(origInputs[frame])
    if isAnyBtnPressed(pressed) then
        inputsToRecord = minimizeBtnSet(pressed, frame)
    else
        console.log('no buttons pressed for frame ' .. frame)
    end

    --client.unpause()
    joypad.set(inputsToRecord)
    emu.frameadvance()

    if emu.framecount() >= totalFrames then
        done = true
    end
end
client.speedmode(100)
client.pause()
console.log('------------')
console.log('success')
