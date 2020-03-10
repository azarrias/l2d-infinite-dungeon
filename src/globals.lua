-- libraries
Class = require 'libs.class'
push = require 'libs.push'

-- general purpose / utility
require 'Animation'
require 'AnimatorCondition'
require 'AnimatorControllerParameter'
require 'AnimatorController'
require 'AnimatorState'
require 'AnimatorStateMachine'
require 'AnimatorStateTransition'
require 'BaseState'
require 'Component'
require 'Entity'
require 'GameStatePlay'
require 'GameStateStart'
require 'Sprite'
require 'StateMachine'
require 'util'
require 'Vector2D'

--[[
    constants
  ]]
GAME_TITLE = 'Infinite Dungeon'

-- OS checks in order to make necessary adjustments to support multiplatform
MOBILE_OS = (love._version_major > 0 or love._version_minor >= 9) and (love.system.getOS() == 'Android' or love.system.getOS() == 'OS X')
WEB_OS = (love._version_major > 0 or love._version_minor >= 9) and love.system.getOS() == 'Web'
  
-- pixels resolution
WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 720
VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 384, 216

PLAYER_WALK_SIZE = Vector2D(16, 32)
PLAYER_SWORD_SIZE = Vector2D(32, 32)

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
  ['entities'] = love.graphics.newImage('graphics/entities.png')
}

FRAMES = {
  ['player-walk-down'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE),
  ['player-walk-right'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE, Vector2D(0, 32)),
  ['player-walk-up'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE, Vector2D(0, 64)),
  ['player-walk-left'] = GenerateQuads(TEXTURES['player'], 1, 4, PLAYER_WALK_SIZE, Vector2D(0, 96))
}
