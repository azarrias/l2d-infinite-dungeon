SceneGameOver = Class{__includes = tiny.Scene}

function SceneGameOver:init()
  self.text = { 
    { string = 'GAME OVER', font = FONTS['zelda'], textColor = {175 / 255, 53 / 255, 42 / 255, 1} },
    { string = 'Press Enter', font = FONTS['zelda-small'] }
  }
end

function SceneGameOver:update(dt)
  if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
    sceneManager:change('Start')
  end
end

function SceneGameOver:render()
  RenderCenteredText(self.text)
end
