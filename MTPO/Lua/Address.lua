-- Provides a Ram map and methods for accessing ram

local Address = {
    Addr = 0,
    Read = function(self)
        return memory.readbyte(self.Addr)
    end
}
  
function Address:new(addr)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.Addr = addr or 0
    return obj
end

addr = {
	['IsInFight'] = Address:new(0x0000),
    ['OppNumber'] = Address:new(0x0001),
    ['_0002'] = Address:new(0x0002), -- Need to understand this better to even know the name
    ['ModeStuff'] = Address:new(0x0004),
    ['WhoIsKnockedDown'] = Address:new(0x0005),
    ['Round'] = Address:new(0x0006),
    ['RNG'] = Address:new(0x0018),
    ['Scrambler'] = Address:new(0x0019),
    ['GlobalTimer'] = Address:new(0x001E),
    ['Timer1'] = Address:new(0x001F),
    ['IsInFightMode'] = Address:new(0x022), 
    ['OpponentTimer'] = Address:new(0x0039),
    ['OpponentMode'] = Address:new(0x003B), -- Related to what routine they are currently in (BB1 rolling jabs, or Great Tiger is jabbing vs uppercuts, etc)
    ['OpponentNextMove'] = Address:new(0x003A), -- Don't understand this one yet
    ['FightEndFlag'] = Address:new(0x0044), -- Don't understand fully yet, but 26 while Mario is declaring Mac the winner
    ['MacCurrentMove'] = Address:new(0x0050),
    ['OpponentCurrentMove'] = Address:new(0x0090),
    ['GameMode'] = Address:new(0x00A9), -- Bad name, but will change if between rounds, intro screen, fight, etc
    ['OppRfpDefense'] = Address:new(0x00B6), -- How opp is defending against a right face punch 0 = will get hit, 4 hit but 1 dmg, 8 = block, 128 = miss and lose heart, default = miss and no heart loss
    ['OppLfpDefense'] = Address:new(0x00B7), -- How opp is defending against a left face punch
    ['OppRgpDefense'] = Address:new(0x00B8), -- How opp is defending against a right gut punch
    ['OppLgpDefense'] = Address:new(0x00B9), -- How opp is defending against a left gut punch
    ['OppMode'] = Address:new(0x00BB), -- 0 in fight, 1 when knocked down, 2 when trying to get up
    ['OppGetUpOnCount'] = Address:new(0x00C4), -- The number the opponent will get up on, 0 = KO'ed, 154 = 1, 155 = 2, etc
    ['BtnsPushed'] = Address:new(0x00D0),
    ['DirectionalBtnsPushed'] = Address:new(0x00D2), -- The buttons pushed but only directional buttons
    ['IsDirectionalBtnsPushed'] = Address:new(0x00D3), -- 1 if any direction is pushed, in fight it has another use, pushing up = 129, seems other bits indicated something as well
    ['StarAnimation'] = Address:new(0x00F5), -- Seems to indicate star animation is happening
    ['WinsTensDigit'] = Address:new(0x0170),
    ['WinsDigit'] = Address:new(0x0171),
    ['LossesTensDigit'] = Address:new(0x0172),
    ['LossesDigit'] = Address:new(0x0173),
    ['KOsTensDigit'] = Address:new(0x0174),
    ['KOsDigit'] = Address:new(0x0175),
    ['ClockMinuteDigit'] = Address:new(0x0302),
    ['ClockColon'] = Address:new(0x0303),
    ['ClockSecondsTensDigit'] = Address:new(0x0304),
    ['ClockSecondsDigit'] = Address:new(0x0305),
    ['ClockSubseconds'] = Address:new(0x0306),
    ['HeartsNextTens'] = Address:new(0x0321),
    ['HeartsNextSingle'] = Address:new(0x0322),
    ['HeartsTens'] = Address:new(0x0323),
    ['HeartsSingle'] = Address:new(0x0324),
    ['Stars'] = Address:new(0x0342),
    ['StarCountdown'] = Address:new(0x0347),
    ['UppercutsUntilOppDodge'] = Address:new(0x0348),
    ['MacHealth'] = Address:new(0x0391),
    ['MacHealthGraudal'] = Address:new(0x0393),
    ['MacNextHealth'] = Address:new(0x0397),
    ['OppHp'] = Address:new(0x0398),
    ['OppHpPrev'] = Address:new(0x0399),
    ['OppHpGradual'] = Address:new(0x039A),
    ['OppNextHealth'] = Address:new(0x039E),
    ['Newspaper'] = Address:new(0x03C9), -- Need to understand this one better
    ['KnockdownsRound'] = Address:new(0x03CA),
    ['TotalKnockdowns'] = Address:new(0x03D1),
    ['IsOppBeingHit'] = Address:new(0x03E0),
    ['ScoreHundredThousandsDigit'] = Address:new(0x03E8),
    ['ScoreTenThousandsDigit'] = Address:new(0x03E9),
    ['ScoreThousandsDigit'] = Address:new(0x03EA),
    ['ScoreHundredsDigit'] = Address:new(0x03EB),
    ['ScoreTensDigit'] = Address:new(0x03EC),
    ['ScoreDigit'] = Address:new(0x03ED),
    ['GuardTimer'] = Address:new(0x04FD),
    ['TotalStarCountdown'] = Address:new(0x05B0),
    ['GuardSpeed1'] = Address:new(0x05B8),
    ['MacMoveTimer'] = Address:new(0x0712), -- Some kind of timer, don't understand fully yet, but seems to be for macs moves
}

