local FONT_H = 8 -- Vertical height of FCEUX font

local fmt = string.format

local color = {
    ["red"] = "red",
    ["lightred"] = "#AA0000",
    ["lightgreen"] = "#007700",
    ["green"] = "green"
}

local RAM = {
    ["RNG"] = 0x0354, -- word
    ["HP"] = 0x60FD,
    ["small_key"] = 0x64DA,
    ["music"] = 0x076C,
    ["sword_quest"] = 0x61FC,
    ["agahnim_flag"] = 0x6303,
    ["key"] = 0x62E6,
    ["rng_dungeon"] = 0x338, -- word
    ["speed"] = 0x6178,
    ["dash_maybe"] = 0x6179,
    ["dash_1947"] = 0x617A,
    ["sword_level"] = 0x62E2
}

function display(x, y)
    local hp = memory.readbyte(RAM.HP)
    gui.text(x, y, fmt("HP: %d", hp), "white", color.lightred)
    local rng = memory.readword(RAM.RNG)
    gui.text(x, y + FONT_H, fmt("RNG: %X", rng))
    local rng_dungeon = memory.readword(RAM.rng_dungeon)
    gui.text(x, y + FONT_H * 2, fmt("DunR: %X", rng_dungeon))
    local speed = memory.readbyte(RAM.speed)
    gui.text(x, y + FONT_H * 3, fmt("Spd: %X", speed))
    local dash19 = memory.readbyte(RAM.dash_1947)
    gui.text(x, y + FONT_H * 4, fmt("Dash: %X", dash19), "white", color.lightgreen)
    local dashmaybe = memory.readbyte(RAM.dash_maybe)
    gui.text(x, y + FONT_H * 5, fmt("Dash2: %X", dashmaybe), "white", color.lightgreen)
end

function dungeon(x, y)
    local small_key = memory.readbyte(RAM.small_key)
    gui.text(x, y, fmt("SKey: %d", small_key))
    local key = memory.readbyte(RAM.key)
    gui.text(x, y + FONT_H, fmt("Key: %d", key))
    local music = memory.readbyte(RAM.music)
    gui.text(x, y + FONT_H * 2, fmt("Music: %d", music))
end

function hp_related(x, y)
    base = 0x6432
    for i = 0, 3 do
        local hp = memory.readbyte(base + i)
        gui.text(x, y + FONT_H * i, fmt("HP%d: %d", i, hp), "white", color.lightred)
    end
end

function info(x, y)
    local sword_quest = memory.readbyte(RAM.sword_quest)
    gui.text(x, y, fmt("Quest: %d", sword_quest))
    local sword_level = memory.readbyte(RAM.sword_level)
    gui.text(x, y + FONT_H, fmt("Sword: %d", sword_level))
end

function main()
    display(0, FONT_H)
    dungeon(60, FONT_H)
    hp_related(210, FONT_H)
    info(180, 214)
end

gui.register(main)
