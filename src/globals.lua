-- libraries
Class = require 'libs.class'
Event = require 'libs.knife.event'
push = require 'libs.push'
Timer = require 'libs.knife.timer'
tiny = require 'libs.tiny'

-- general purpose / utility
require 'BehaviourEntityIdle'
require 'BehaviourEntityMovingDown'
require 'BehaviourEntityMovingLeft'
require 'BehaviourEntityMovingRight'
require 'BehaviourEntityMovingUp'
require 'BehaviourPlayerAttackingDown'
require 'BehaviourPlayerAttackingLeft'
require 'BehaviourPlayerAttackingRight'
require 'BehaviourPlayerAttackingUp'
require 'BehaviourPlayerMovingDown'
require 'BehaviourPlayerMovingLeft'
require 'BehaviourPlayerMovingRight'
require 'BehaviourPlayerMovingUp'
require 'Doorway'
require 'EntityController'
require 'PlayerController'
require 'Room'
require 'SceneDungeon'
require 'SceneGameOver'
require 'SceneStart'
require 'util'

--[[
    constants
  ]]
GAME_TITLE = 'Infinite Dungeon'
DEBUG_MODE = true

-- OS checks in order to make necessary adjustments to support multiplatform
MOBILE_OS = (love._version_major > 0 or love._version_minor >= 9) and (love.system.getOS() == 'Android' or love.system.getOS() == 'OS X')
WEB_OS = (love._version_major > 0 or love._version_minor >= 9) and love.system.getOS() == 'Web'
  
-- pixels resolution
WINDOW_SIZE = tiny.Vector2D(1280, 720)
VIRTUAL_SIZE = tiny.Vector2D(384, 216)

TILE_SIZE = 16
SWITCH_SIZE = tiny.Vector2D(16, 18)
PLAYER_WALK_SIZE = tiny.Vector2D(16, 32)
PLAYER_ATTACK_SIZE = tiny.Vector2D(32, 32)
ENTITY_SIZE = tiny.Vector2D(16, 16)

-- room tile map number of tiles
MAP_SIZE = (VIRTUAL_SIZE / TILE_SIZE - tiny.Vector2D(2, 2)):Floor()
MAP_RENDER_OFFSET = ((VIRTUAL_SIZE - MAP_SIZE * TILE_SIZE) / 2):Floor()

-- resources
FONTS = {
  ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
  ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
  ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
  ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
  ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
  ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 48),
  ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 24)
}

TEXTURES = {
  ['player'] = love.graphics.newImage('graphics/character.png'),
  ['entities'] = love.graphics.newImage('graphics/entities.png'),
  ['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
  ['switches'] = love.graphics.newImage('graphics/switches.png'),
  ['background'] = love.graphics.newImage('graphics/background.png')
}

FRAMES = {
  ['player-walk-down'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE),
  ['player-walk-right'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE, tiny.Vector2D(0, 32)),
  ['player-walk-up'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE, tiny.Vector2D(0, 64)),
  ['player-walk-left'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE, tiny.Vector2D(0, 96)),
  ['player-attack-down'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_ATTACK_SIZE, tiny.Vector2D(0, 128)),
  ['player-attack-up'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_ATTACK_SIZE, tiny.Vector2D(0, 160)),
  ['player-attack-right'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_ATTACK_SIZE, tiny.Vector2D(0, 192)),
  ['player-attack-left'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_ATTACK_SIZE, tiny.Vector2D(0, 224)),
  ['tiles'] = GenerateAllQuads(TEXTURES['tiles'], TILE_SIZE, TILE_SIZE),
  ['skeleton-move-down'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 0)),
  ['skeleton-move-left'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 16)),
  ['skeleton-move-right'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 32)),
  ['skeleton-move-up'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 48)),
  ['slime-move-down'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(0, 64)),
  ['slime-move-left'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(0, 80)),
  ['slime-move-right'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(0, 96)),
  ['slime-move-up'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(0, 112)),
  ['bat-move-down'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 64)),
  ['bat-move-left'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 80)),
  ['bat-move-right'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 96)),
  ['bat-move-up'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(48, 112)),
  ['ghost-move-down'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(96, 64)),
  ['ghost-move-left'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(96, 80)),
  ['ghost-move-right'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(96, 96)),
  ['ghost-move-up'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(96, 112)),
  ['spider-move-down'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 64)),
  ['spider-move-left'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 80)),
  ['spider-move-right'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 96)),
  ['spider-move-up'] = GenerateQuads(TEXTURES['entities'], 1, 3, ENTITY_SIZE, tiny.Vector2D(144, 112)),
  ['door-open-left'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(144, 144)),
  ['door-closed-left'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(144, 176)),
  ['door-open-right'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(0, 144)),
  ['door-closed-right'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(32, 144)),
  ['door-open-top'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(32, 80)),
  ['door-closed-top'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(0, 112)),
  ['door-open-bottom'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(112, 112)),
  ['door-closed-bottom'] = GenerateQuads(TEXTURES['tiles'], 2, 2, tiny.Vector2D(TILE_SIZE, TILE_SIZE), tiny.Vector2D(96, 176)),
  ['switches'] = GenerateAllQuads(TEXTURES['switches'], SWITCH_SIZE.x, SWITCH_SIZE.y)
}

SOUNDS = {
  ['door'] = love.audio.newSource('sounds/door.wav', 'static'),
  ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav', 'static'),
  ['hit-player'] = love.audio.newSource('sounds/hit_player.wav', 'static'),
  ['sword'] = love.audio.newSource('sounds/sword.wav', 'static')
}

-- tile IDs
TILE_EMPTY = 19

TILE_TOP_LEFT_CORNER = 4
TILE_TOP_RIGHT_CORNER = 5
TILE_BOTTOM_LEFT_CORNER = 23
TILE_BOTTOM_RIGHT_CORNER = 24

TILE_TOP_WALLS = {58, 59, 60}
TILE_BOTTOM_WALLS = {79, 80, 81}
TILE_LEFT_WALLS = {77, 96, 115}
TILE_RIGHT_WALLS = {78, 97, 116}

TILE_FLOORS = { 
  7, 8, 9, 10, 11, 12, 13,
  26, 27, 28, 29, 30, 31, 32,
  45, 46, 47, 48, 49, 50, 51,
  64, 65, 66, 67, 68, 69, 70,
  88, 89, 107, 108
}
