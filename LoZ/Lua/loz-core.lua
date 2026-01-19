local _done = false
local _config = client.getconfig()

local function _doFrame(keys)
	if (keys ~= nil) then
		if (type(keys.ToTable) == 'function') then
			keys = keys.ToTable()
		end

		joypad.set(keys)
	end

	emu.frameadvance()
end

function _addP(str)
	if (not bizstring.startswith(str, 'P1')) then
		return 'P1 ' .. str
	end

	return str
end

local function _buttons()
    local btns = {
		['P1 Up'] = false,
		['P1 Down'] = false,
		['P1 Left'] = false,
		['P1 Right'] = false,
		['P1 B'] = false,
		['P1 A'] = false,
		['P1 Select'] = false,
		['P1 Start'] = false,
	}

    btns.With = function(b1, b2, b3, b4, b5, b6, b7, b8)
		if b1 == nil then
			error('b1 cannot be nil')
		end

		btns[_addP(b1)] = true
		if b2 ~= nil then
			btns[_addP(b2)] = true
		end
		if b3 ~= nil then
			btns[_addP(b3)] = true
		end
		if b4 ~= nil then
			btns[_addP(b4)] = true
		end
		if b5 ~= nil then
			btns[_addP(b5)] = true
		end
		if b6 ~= nil then
			btns[_addP(b6)] = true
		end
		if b7 ~= nil then
			btns[_addP(b7)] = true
		end
		if b8 ~= nil then
			btns[_addP(b8)] = true
		end

		return btns
	end

    btns.ToTable = function()
		return {
			['P1 Up'] = btns['P1 Up'],
			['P1 Down'] = btns['P1 Down'],
			['P1 Left'] = btns['P1 Left'],
			['P1 Right'] = btns['P1 Right'],
			['P1 B'] = btns['P1 B'],
			['P1 A'] = btns['P1 A'],
			['P1 Select'] = btns['P1 Select'],
			['P1 Start'] = btns['P1 Start']
		}
	end

    return btns
end

local function _doFrame(keys)
	if (keys ~= nil) then
		if (type(keys.ToTable) == 'function') then
			keys = keys.ToTable()
		end

		joypad.set(keys)
	end

	emu.frameadvance()
end

local function _isDebug()
	return _config.SpeedPercent < 800
end

c = {
    Directions = {
        Right = 1,
        Left = 2,
        Down = 4,
        Up = 8,
    },
    GameModes = {
        Transition = 0,
        SelectionScreen = 1,
        FinishScroll = 4,
        Normal = 5,
        PrepareScroll = 6,
        Scrolling = 7,
        Cave = 0x0B,
        Dungeon = 0x09,
        LeavingDungeon = 0x10,
        Registration = 0xE,
        Elimination = 0xF,
    },
    ToSignedByte = function(b)
        if b > 127 then
        return b - 256
        else
            return b
        end
    end,
    ToHex = function(b)
        return string.format("%02X", b)
    end,
    ToLeftNibble = function(b)
        return string.sub(string.format("%01X", b), 1, 1)
    end,
    Debug = function(msg)
		if _isDebug() then
			console.log(msg)
		end
	end,
    Done = function()
		_done = true
	end,
	IsDone = function()
		return _done
	end,
    Done = function()
		_done = true
	end,
    Start = function()
        client.unpause()
        client.speedmode(800)
    end,
    Finish = function()
        console.log('---------------')
        client.speedmode(100)
        client.pause()
        if _done then
		    console.log('Success!')
            c.Save('Success' .. emu.framecount())
		    c.Save(99)
        end
    end,
    Save = function(slot)
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
	end,
	Load = function(slot)
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
	end,
    GameMode = function()
        return memory.readbyte(0x0012)
    end,
    Player = function()
        return {
            x = memory.readbyte(0x0070),
            y = memory.readbyte(0x0084),
            direction = memory.readbyte(0x0098),
        }
    end,
    Enemy = function(n)
        i = n - 1

        local enemy = {
            num = n,
            x = memory.readbyte(0x0071 + i),
            y = memory.readbyte(0x0085 + i),
            direction = memory.readbyte(0x099 + i),
            type = memory.readbyte(0x0350 + i),
            hp = memory.readbyte(0x0486 + i),
            timer = memory.readbyte(0x0029 + i),
            invulnTimer = memory.readbyte(0x04F1 + i),
            target = memory.readbyte(0x0413 + i)
        }

        return enemy
    end,
    WaitFor = function(frames)
		if (frames > 0) then
			for i = 1, frames, 1 do
				emu.frameadvance()
			end
		end
	end,
    PushFor = function(btn, frames)
		if not frames then
			frames = 1
		end
		for i = 1, frames, 1 do
            btns = _buttons().With(btn)
			_doFrame(btns)
		end
	end,
    PushUpAndSelect = function()
        local btns = _buttons().With('Select').With('Up')
        _doFrame(btns)
    end,
    PushStart = function(numFrames)
		c.PushFor('Start', numFrames)
	end,
    PushSelect = function(numFrames)
		c.PushFor('Select', numFrames)
	end,
	PushB = function(numFrames)
		c.PushFor('B', numFrames)
	end,
	PushA = function(numFrames)
		c.PushFor('A', numFrames)
	end,
	PushUp = function(numFrames)
		c.PushFor('Up', numFrames)
	end,
    PushDown = function(numFrames)
		c.PushFor('Down', numFrames)
	end,
    PushLeft = function(numFrames)
		c.PushFor('Left', numFrames)
	end,
    PushRight = function(numFrames)
		c.PushFor('Right', numFrames)
	end,
    RightUntil = function(targetX)
        x = memory.readbyte(0x0070)
        while x < targetX do
            x = memory.readbyte(0x0070)
            c.PushRight()
        end
    end,
    LeftUntil = function(targetX)
        x = memory.readbyte(0x0070)
        while x > targetX do
            x = memory.readbyte(0x0070)
            c.PushLeft()
        end
    end,
    UntilNextInputFrame = function()
        if not emu.islagged() then
            c.WaitFor(1)
            if not emu.islagged() then
                error('This function must be run during lag, or one frame before it')
            end
        end

        c.Save("CoreTemp")
        local startFrameCount = emu.framecount()

        while emu.islagged() do
            c.WaitFor(1)
        end

        local endFrameCount = emu.framecount()
        local targetFrames = endFrameCount - startFrameCount - 1

        c.Load("CoreTemp")
        if targetFrames > 0 then
            c.WaitFor(targetFrames)
        end
    end,
    UntilNextLagFrame = function()
        if emu.islagged() then
            console.log('already lag')
            return
        end

        c.Save("CoreTemp")
        local startFrameCount = emu.framecount()

        while not emu.islagged() do
            c.WaitFor(1)
        end

        local endFrameCount = emu.framecount()
        local targetFrames = endFrameCount - startFrameCount - 1

        c.Load("CoreTemp")
        if targetFrames > 0 then
            c.WaitFor(targetFrames)
        end
    end,
    Quest = function()
        --TODO: this logic will fail on registration or elimination screens
        -- they return higher values for current slot value (for 4th and 5th menu options)
        currSaveSlot = memory.readbyte(0x0016)

        --062D = slot 1, E = 2, F = 3
        quest = memory.readbyte(0x062D + currSaveSlot)
        return quest + 1
    end,
    Level = function()
        return memory.readbyte(0x10)
    end,
    Screen = function()
        return memory.readbyte(0x00EB)
    end,
    NextScreen = function()
        return memory.readbyte(0x00EC)
    end,
}