-- Counts up the number of delay frames done
local c = require("DW4-ManipCore")
local wasInput = false
local delayCount = 0
c.Log('Counting delay frames')
while not c.done do
    emu.frameadvance()
    if not emu.islagged() then
        if wasInput then
            c.Log('Delay Frame, Total: ' .. delayCount)
            delayCount = delayCount + 1
        end        
    end
    wasInput = not emu.islagged()
    

    
end

