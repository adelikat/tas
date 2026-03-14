local verboseLogging = false
local targetFrame = 1000 -- how many frames to advance to ensure memory is synced after changing inputs
local toNextMarker = false -- if true, will process frames between current frame and next marker, otherwise will process frames between previous and next marker
local mode = movie.mode()

if not tastudio.engaged() then
    error('Tastudio needs to be engaged')
end

if mode ~= 'PLAY' then
    error('Movie needs to be in playback mode, current mode: ' .. mode)
end

function Log(msg)
    console.log(msg)
end

--use console log, for debugging, support params like console.log does
function Debug(str)
    if verboseLogging then
        console.log('debug--')
        console.log(str)
    end
end

function getAllMemory()
    return mainmemory.read_bytes_as_array(0x0000, 0x07FF)
end

local function getPressedBtns(btns)
    local pressed = {}

    for k, v in pairs(btns or {}) do
        if v == "True" or v == true then
            pressed[k] = v
        end
    end

    return pressed
end

local function areArraysTheSame(arr1, arr2)
    if #arr1 ~= #arr2 then
        Log('Error - arrays are different lengths: ' .. #arr1 .. ' vs ' .. #arr2)
        return false
    end

    for k, v in pairs(arr1) do
        if arr2[k] ~= v then
            Debug('difference found in byte ' .. k .. ': ' .. string.format("%02X", v) .. ' vs ' .. string.format("%02X", arr2[k]))
            return false
        end
    end

    return true
end

local function getMarkerbefore(frame)
    local frames = tastudio.get_frames_with_markers()
    local lastFrame = nil

    for k, v in pairs(frames) do
        if v < frame then
            lastFrame = v
        else
            break
        end
    end

    return lastFrame
end

local function getMarkerAfter(frame)
    local frames = tastudio.get_frames_with_markers()

    for k, v in pairs(frames) do
        if v > frame then
            return v
        end
    end
end

function navigateTo(frame)
    client.unpause()
    tastudio.setplayback(frame)
    while emu.framecount() < frame do
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

local function minimizeButtonsOnFrame(frame, currentFrame)
    local btns = getPressedBtns(movie.getinput(frame))
    Debug('btns for frame ' .. frame)
    Debug(btns)
    if not isAnyBtnPressed(btns) then
        Log('no buttons pressed for frame ' .. frame)
        return
    end

    navigateTo(frame + targetFrame)
    local syncedMemory = getAllMemory()
    navigateTo(frame)

    for k, v in pairs(btns) do
        tastudio.submitinputchange(frame, k, false)
        tastudio.applyinputchanges()

        navigateTo(frame + targetFrame)
        local newMemory = getAllMemory()
        local result = areArraysTheSame(syncedMemory, newMemory)
        if result then
            Log('Sync Success! keeping ' .. k .. ' off')
        else
            Log('Sync Failed! ' .. k .. ' is needed')
            navigateTo(frame)
            tastudio.submitinputchange(frame, k, true)
            tastudio.applyinputchanges()
        end
    end


end

local currentFrame = emu.framecount()
Log('starting frame', currentFrame)
local startFrame = getMarkerbefore(currentFrame)
if startFrame == nil then
    error('No marker found before current frame')
end

endFrame = movie.length() - 1

if toNextMarker then
    endFrame = getMarkerAfter(currentFrame)
end
if endFrame == nil then
    endFrame = movie.length() - 1
end

Log('processing frames between ' .. startFrame .. ' and ' .. endFrame)

local done = false
client.unpause()
client.speedmode(1600)
local currentFrame = startFrame
while not done do
    console.log('navigating to frame ' .. currentFrame)
    navigateTo(currentFrame)
    console.log('navigated to frame ' .. currentFrame)
    minimizeButtonsOnFrame(currentFrame)
    currentFrame = currentFrame + 1

    if currentFrame > endFrame then
        done = true
    else
        Log('advancing to ' .. currentFrame)
    end
end

client.speedmode(100)
client.pause()
Log('------------')
Log('DONE')
Log('------------')
