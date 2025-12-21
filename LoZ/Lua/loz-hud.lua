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

function screenScrollHelper()
    direction = memory.readbyte(0x0098)
    x = memory.readbyte(0x0070)
    y = memory.readbyte(0x0084)
    color = 'white'
    if (direction == Directions.Left and x == 5)
        or (direction == Directions.Right and x == 0)
        or (direction == Directions.Right and x == 235)
        or (direction == Directions.Down and y == 216) then
        color = 'green'
    end

    if (direction == facingRight and x == 16)
        or (direction == Directions.Right and x == 16)
        or (direction == Directions.Left and x == 240)
        or (direction == Directions.Left and x == 224)
        or (direction == Directions.Up and y == 205)
        or (direction == Directions.Down and y == 61) then
        color = 'yellow'
    end

    if direction == Directions.Left then
        gui.drawLine(x, y - 8, x, y + 16, color)
    elseif direction == Directions.Right then
        gui.drawLine(x + 12, y - 8, x + 12, y + 16, color)
    elseif direction == Directions.Up then
        gui.drawLine(x, y - 8, x + 16, y - 8, color)
    elseif direction == Directions.Down then
        gui.drawLine(x, y + 7, x + 16, y + 7, color)
    end
end

local function toSignedByte(b)
    if b > 127 then
        return b - 256
    else
        return b
    end
end

local function toHex(b)
    return string.format("%02X", b)
end

local function getGameMode()
    return memory.readbyte(0x0012)
end

local function toLeftNibble(b)
    return string.sub(string.format("%01X", b), 1, 1)
end

local function getEnemy(n)
    i = n - 1

    local enemy = {
        num = n,
        x = memory.readbyte(0x0071 + i),
        y = memory.readbyte(0x0085 + i),
        direction = memory.readbyte(0x099 + i),
        type = memory.readbyte(0x0350 + i),
        hp = memory.readbyte(0x0486 + i),
        timer = memory.readbyte(0x0029 + i)
    }

    return enemy
end

local function drawEnemy(enemy)
    if enemy.type == 0 then
        return
    end

    local mode = getGameMode()
    if mode ~= GameModes.Normal and mode ~= GameModes.Cave then
        return
    end

    gui.drawRectangle(enemy.x, enemy.y - 8, 16, 16, 'white')

    if enemy.direction == Directions.Left then
        gui.drawLine(enemy.x, enemy.y - 8, enemy.x, enemy.y + 8, 'green')
    elseif enemy.direction == Directions.Right then
        gui.drawLine(enemy.x + 16, enemy.y - 8, enemy.x + 16, enemy.y + 8, 'green')
    elseif enemy.direction == Directions.Up then
        gui.drawLine(enemy.x, enemy.y - 8, enemy.x + 16, enemy.y - 8, 'green')
    elseif enemy.direction == Directions.Down then
        gui.drawLine(enemy.x, enemy.y + 8, enemy.x + 16, enemy.y + 8, 'green')
    end

    if enemy.hp > 16 and mode == GameModes.Normal then
        gui.drawText(enemy.x, enemy.y + 8, toLeftNibble(enemy.hp))
    end

    if mode == GameModes.Cave and enemy.timer > 0 then
        gui.drawText(enemy.x + 16, enemy.y + 8, enemy.timer )
    end

end

local function moneyMakingDisplay(val)
    if val == 10 then
        return '-10'
    elseif val == 20 then
        return '+20'
    elseif val == 40 then
        return '-40'
    elseif val == 50 then
        return '+50'
    end
end

local function moneyMakingColor(val)
    if val == 10 or val == 40 then
        return 'red'
    end

    return 'green'
end

local function moneyMakingHud()
    if getGameMode() ~= GameModes.Cave then
       return
    end

    left = memory.readbyte(0x0448)
    middle = memory.readbyte(0x0449)
    right = memory.readbyte(0x044A)
    if left == 0 then
        return
    end

    gui.drawText(80, 176, moneyMakingDisplay(left), moneyMakingColor(left))
    gui.drawText(112, 176, moneyMakingDisplay(middle), moneyMakingColor(middle))
    gui.drawText(144, 176, moneyMakingDisplay(right), moneyMakingColor(right))
end

while true do
	screenScrollHelper()
    moneyMakingHud()

    drawEnemy(getEnemy(1))
    drawEnemy(getEnemy(2))
    drawEnemy(getEnemy(3))
    drawEnemy(getEnemy(4))
    drawEnemy(getEnemy(5))
    drawEnemy(getEnemy(6))

	emu.frameadvance();
end
