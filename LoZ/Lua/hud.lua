dofile('loz-core.lua')

function screenScrollHelper()
    p = c.Player();
    color = 'white'
    if (p.direction == c.Directions.Left and p.x == 5)
        or (p.direction == c.Directions.Right and p.x == 0)
        or (p.direction == c.Directions.Right and p.x == 235)
        or (p.direction == c.Directions.Down and p.y == 216)
        or (p.direction == c.Directions.Up and p.y == 66) then
        color = 'green'
    end

    if (p.direction == c.Directions.Right and p.x == 16)
        or (p.direction == c.Directions.Right and p.x == 16)
        or (p.direction == c.Directions.Left and p.x == 240)
        or (p.direction == c.Directions.Left and p.x == 224)
        or (p.direction == c.Directions.Up and p.y == 205)
        or (p.direction == c.Directions.Down and p.y == 61) then
        color = 'yellow'
    end

    if (p.direction == c.Directions.Down and p.y == 77) then
        color = 'yellow'
    end

    if p.direction == c.Directions.Left then
        gui.drawLine(p.x, p.y - 8, p.x, p.y + 16, color)
    elseif p.direction == c.Directions.Right then
        gui.drawLine(p.x + 12, p.y - 8, p.x + 12, p.y + 16, color)
    elseif p.direction == c.Directions.Up then
        gui.drawLine(p.x, p.y - 8, p.x + 16, p.y - 8, color)
    elseif p.direction == c.Directions.Down then
        gui.drawLine(p.x, p.y + 7, p.x + 16, p.y + 7, color)
    end
end

local function drawEnemy(enemy)
    if enemy.type == 0 then
        return
    end

    local mode = c.GameMode()
    if mode ~= c.GameModes.Normal and mode ~= c.GameModes.Cave then
        return
    end

    color = 'white'
    if (enemy.num == 1) then
        color = 'gray'
    end

    gui.drawRectangle(enemy.x, enemy.y - 8, 16, 16, color)

    if enemy.direction == c.Directions.Left then
        gui.drawLine(enemy.x, enemy.y - 8, enemy.x, enemy.y + 8, 'green')
    elseif enemy.direction == c.Directions.Right then
        gui.drawLine(enemy.x + 16, enemy.y - 8, enemy.x + 16, enemy.y + 8, 'green')
    elseif enemy.direction == c.Directions.Up then
        gui.drawLine(enemy.x, enemy.y - 8, enemy.x + 16, enemy.y - 8, 'green')
    elseif enemy.direction == c.Directions.Down then
        gui.drawLine(enemy.x, enemy.y + 8, enemy.x + 16, enemy.y + 8, 'green')
    end

    if enemy.hp > 16 and mode == c.GameModes.Normal then
        gui.drawText(enemy.x, enemy.y + 8, c.ToLeftNibble(enemy.hp))
    end

    if mode == c.GameModes.Cave and enemy.timer > 0 then
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
    if c.GameMode() ~= c.GameModes.Cave then
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

    drawEnemy(c.Enemy(1))
    drawEnemy(c.Enemy(2))
    drawEnemy(c.Enemy(3))
    drawEnemy(c.Enemy(4))
    drawEnemy(c.Enemy(5))
    drawEnemy(c.Enemy(6))
    drawEnemy(c.Enemy(7))

	emu.frameadvance();
end
