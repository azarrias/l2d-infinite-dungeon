-- libraries
Class = require 'libs.class'
push = require 'libs.push'

-- general purpose / utility
require 'BaseState'
require 'GameStateStart'
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
