done = false
increment = 5000
if (increment < 1000) then
    console.log('only increments of 1000 are supported currently')
end
mode = movie.mode()
if mode == 'INACTIVE' then
    done = true
    console.log('movie not loaded, stopping')
end

function mysplit(str, delim)
    local result = {}
    local start = 1

    if delim == "" then
        -- Edge case: split into characters
        for i = 1, #str do
            result[#result + 1] = str:sub(i, i)
        end
        return result
    end

    while true do
        local pos = string.find(str, delim, start, true) -- plain search
        if not pos then
            result[#result + 1] = str:sub(start)
            break
        end

        result[#result + 1] = str:sub(start, pos - 1)
        start = pos + #delim
    end

    return result
end

function getVersion()
    filename = movie.filename()
    splits = mysplit(filename, 'adelikat-v')
    strVersion = string.sub(splits[2], 1, 1)
    if (string.len(strVersion) < 1) then
        console.log('unable to determine string version')
    end

    return tonumber(strVersion)
end

version = getVersion()
if not version then
    console.log('unable to determine string version')
end

console.log('savestating engaged, will save every ' .. increment .. ' frames')
prefix = 'a-v' .. version .. '-'
console.log('prefix', prefix)

while not done do
    mode = movie.mode()
    if mode ~= 'PLAY' then
        done = true
        console.log('movie finished, stopping')
    else
        framecount = emu.framecount()
        if (framecount % increment == 0 and framecount > 0) then
            stateFilename = prefix .. math.floor((framecount / 1000)) .. 'k.State'
            console.log('savstating: ', stateFilename)
            savestate.save(stateFilename)
        end
        --console.log('movieFile: ' .. movieFile)
    end


    emu.frameadvance()
end

