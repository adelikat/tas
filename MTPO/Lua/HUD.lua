--TODO
--Indicate that an opponent is KO'ed when they get knocked down, instead of showing next health
--"Where am I" still has issues, bike scene is "between rounds", knocked down is knocked down for a bit but then something else
--Guard values
-- show rng and scrambler?
dofile('MTPO-Core.lua')
function __clear()
	gui.clearGraphics()
end
event.onexit(__clear)

function _numberToImage(twoDigitNumber, x, y, color)
	if color == nil then
		color = 'white'
	end
	if twoDigitNumber < 0 then
		gui.drawImage(string.format('./icons/%s-dash.png', color), x, y)
		x = x + 8
		twoDigitNumber = math.abs(twoDigitNumber)
	end

	local first = math.floor(twoDigitNumber / 10)
	local firstImage = string.format('./icons/%s-%s.png', color, first)
	gui.drawImage(firstImage, x, y)	

	local last = twoDigitNumber % 10
	local lastImage = string.format('./icons/%s-%s.png', color, last)
	gui.drawImage(lastImage, x + 8, y)
end

function _countInStr(base, pattern)
    return select(2, string.gsub(base, pattern, ""))
end

function _strWidth(str)
	if str == nil then
		return 0
	end
    local periods = _countInStr(str, '%.')
	local spaces = _countInStr(str, ' ')
	local remaining = string.len(str) - periods - spaces
	local strWidth = (remaining * 8) + (periods * 4) + (spaces * 4)
	return strWidth
end

function _textToImage(str, x, y)
	if str == nil then
		return
	end

	str = string.lower(str)
	for i = 1, #str do
		local c = str:sub(i,i)
		if c == '.' then
			gui.drawImage('./icons/white-period.png', x, y)
			x = x + 4
		elseif c == '-' then
			gui.drawImage('./icons/white-dash.png', x, y)
			x = x + 8
		elseif c == ' ' then
			x = x + 4
		else
			local image = string.format('./icons/white-%s.png', c)
			gui.drawImage(image, x, y)
			x = x + 8
		end		
	 end
end

-- Some rings are offset by 1 pixel for some reason
local function _isRngOffSet()
	local opp = c.Read(c.Addr.OppNumber)
	if opp == 2 or opp == 6 or opp == 7 or opp == 8 or opp == 9 or opp == 11 or opp == 12 or opp == 13 or opp == 19 or opp == 22 or opp == 23 or opp == 24 or opp == 26 or opp == 27 or opp == 28 then
		return true
	end
end

local function _drawHealthBar(x1, y1, hp, dmg, color)
	local opp = c.Read(c.Addr.OppNumber)
	if _isRngOffSet() then
		x1 = x1 + 1
	end
	local y2 = 22
	-- Draw over the existing bar with black
	gui.drawBox(x1, y1, x1 + 47, y2, 'black', 'black')
	local textColor = 'white'
	if hp > 0 then
		if color == nil then
			color = 'ForestGreen'
			if hp < 24 then
				color = 'pink'
				textColor = 'red'
			elseif hp < 48 then
				textColor = 'yellow'
				color = 'Gold'
			end
		end

		local x2 = math.ceil(x1 + hp / 2) - 1
		gui.drawBox(x1 - 1, y1 - 9, x1 + 16, y1 - 1, 'black', 'black')
		gui.drawBox(x1, y1, x2, y2, color, color)
		_numberToImage(hp, x1 , y1 - 8, textColor)

		if dmg > 0 then
			gui.drawBox(x2, y1, x2 + math.ceil((dmg / 2)), y2, 'Crimson', 'Crimson')
			gui.drawBox(x1 + 16, y1 - 9, x1 + 40 , y1 - 1, 'black', 'black')
			_numberToImage(0 - dmg, x1 + 16, y1 - 8, 'red')
		end
	end
end

local function _guardSymbol(val)
	if val == 0 then
		return 'O'
	end
	if val == 4 then
		return '1'
	end

	return 'X'
end

local function _guardSymbolColor(val)
	if val == 0 then
		return 'Green'
	end
	if val == 4 then
		return 'GreenYellow'
	end

	return 'Gray'
end

hud = {
	Opp = function()
		if not c.IsInFight() then
			return
		end

		local txt = c.CurrentOpponent()
		local backdropWidth = _strWidth(txt) + 2
		gui.drawRectangle(0, 0, backdropWidth, 9, 'Black', 'Black')
		_textToImage(txt, 0, 0)
	end,
	Health = function()
		if not c.IsInFight() then
			return
		end

		local hp, dmg, color
		if c.IsOppKnockedDown() then
			if c.IsOpponentKnockedOut() then
				hp = 0
			else
				hp = c.Read(c.Addr.OppNextHealth)
			end			
			dmg = 0
			color = 'darkgray'
		elseif c.IsOppBeingHit() then
			hp = c.Read(c.Addr.OppHp)
			dmg = c.LastDamage()
			color = nil
		else
			hp = c.Read(c.Addr.OppHp)
			dmg = c.Read(c.Addr.OppHpGradual) - hp
			color = nil
		end
		
		_drawHealthBar(144, 16, hp, dmg, color)
		
		if c.IsMacKnockedDown() then
			hp = c.Read(c.Addr.MacNextHealth)			
			dmg = 0
			color = 'darkgray'
		else
			hp = c.Read(c.Addr.MacHealth)
			dmg = c.Read(c.Addr.MacHealthGraudal) - hp
			color = nil	
		end

		-- Mac
		_drawHealthBar(88, 16, hp, dmg, color)
	end,
	StarCountdown = function()	
		if not c.IsInFight() then
			return
		end
			
		totalPunchesToGetStar = c.Read(c.Addr.TotalStarCountdown)
		if totalPunchesToGetStar <= 1 then
			return
		end
		punchesLeftToGetStar = c.Read(c.Addr.StarCountdown)
		local totalWidth = 26
		local percent = punchesLeftToGetStar / totalPunchesToGetStar
		local width = totalWidth * percent
		gui.drawLine(13, totalWidth, 13 + totalWidth, 26, 'darkGray')
		gui.drawLine(13, 26, 13 + width, 26, 'blue')
	end,
	Mode = function()
		local mode = c.Mode()
		gui.drawText(256, 226, mode, 'white', nil, nil, nil, nil, 'right', 'bottom')
	end,
	UppercutsUntilDodge = function()
		if not c.IsInFight() then
			return
		end

		local count = c.Read(c.Addr.UppercutsUntilOppDodge)
		gui.drawRectangle(0, 22, 7, 9, 'Black', 'Black')
		_numberToImage(count, -6, 24)
		gui.drawRectangle(9, 28, 62, 2, 'Black', 'Black')
		local width = count * 2
		gui.drawRectangle(9, 28, width, 2, 'White', 'White')
	end,
	Phase = function()
		if not c.IsInFight() then
			return
		end

		gui.drawRectangle(201, 0, 54, 9, 'Black', 'Black')
		local phase = c.Read(c.Addr.KnockdownsRound)
		local text
		if phase == 3 then
			text = 'TKO'	
		elseif c.IsOppKnockedDown() and c.OpponentWillGetUpOnCount() == 0 then
			text = 'KO'
		else
			text = string.format('Phase %s', phase + 1)
		end
		_textToImage(text, 202, 1)
	end,
	OppMoves = function()
		if not c.IsInFight() then
			return
		end

		if c.Read(0x22) == 1 then
			return
		end

		_textToImage(c.GetMove(), 168, 98)		
		timer = c.Read(c.Addr.OpponentTimer)
		gui.drawRectangle(168, 108, timer, 4, 'gray', 'White')
	end,
	OppCount = function()
		local oppCount = c.OpponentWillGetUpOnCount()
		if oppCount > 0 then
			_textToImage(oppCount .. ' count ', 162, 118)
		end
	end,
	Guard = function()
		if not c.IsInFight() or c.IsOppKnockedDown() then
			return
		end

		rfp = c.Read(c.Addr.OppRfpDefense)
		lfp = c.Read(c.Addr.OppLfpDefense)
		rgp = c.Read(c.Addr.OppRgpDefense)
		lgp = c.Read(c.Addr.OppLgpDefense)

		gui.drawRectangle(64, 90, 9, 8, 'Gray', _guardSymbolColor(lfp))
		gui.drawRectangle(73, 90, 9, 8, 'Gray', _guardSymbolColor(rfp))
		gui.drawRectangle(64, 98, 9, 8, 'Gray', _guardSymbolColor(lgp))
		gui.drawRectangle(73, 98, 9, 8, 'Gray', _guardSymbolColor(rgp))
		_textToImage(_guardSymbol(lfp), 66, 91)
		_textToImage(_guardSymbol(rfp), 75, 91)
		_textToImage(_guardSymbol(lgp), 66, 99)
		_textToImage(_guardSymbol(rgp), 75, 99)


		
		
	end
}

hud.Display = function()
	c.TrackHealth()
	gui.clearGraphics()	
	hud.Opp()
	hud.Health()
	hud.StarCountdown()
	hud.Mode()
	hud.UppercutsUntilDodge()
	hud.Phase()
	hud.OppMoves()
	hud.OppCount()
	hud.Guard()
end
------------------------------------------------------------------------------------------------

while true do
	hud.Display()
	emu.frameadvance();
end
