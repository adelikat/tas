local mode = movie.mode()

if mode ~= 'PLAY' then
    error('Movie needs to be in playback mode, current mode: ' .. mode)
end

client.unpause()

local done = false

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

while not done do
    local frame = emu.framecount()
    local btns = movie.getinput(frame)
    local pressed = getPressedBtns(btns)
    console.log('btns', btns)
    console.log('pressed', pressed)

    emu.frameadvance()
    done = true
end

client.pause()
console.log('------------')
console.log('success')
