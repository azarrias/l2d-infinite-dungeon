require 'globals'

local FONT_SIZE = 16

function love.load()
  if arg[#arg] == "-debug" then 
    require("mobdebug").start() 
  end
  
  io.stdout:setvbuf("no")

  -- use nearest-neighbor (point) filtering on upscaling and downscaling to prevent blurring of text and 
  -- graphics instead of the bilinear filter that is applied by default 
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- Set up window
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = MOBILE_OS,
    resizable = not MOBILE_OS
  })
  love.window.setTitle(GAME_TITLE)
  
  gameStateMachine = StateMachine {
    ['start'] = function() return GameStateStart() end,
    ['play'] = function() return GameStatePlay() end,
    ['game-over'] = function() return GameStateGameOver() end
  }
  gameStateMachine:change('start')
  
  love.keyboard.keysPressed = {}
end

function love.update(dt)
  -- exit if esc is pressed
  if love.keyboard.keysPressed['escape'] then
    love.event.quit()
  end
  
  gameStateMachine:update(dt)
  
  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end
  
-- Callback that processes key strokes just once
-- Does not account for keys being held down
function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.draw()
  push:start()
  gameStateMachine:render()
  push:finish()
end