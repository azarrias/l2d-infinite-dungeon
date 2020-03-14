SceneStart = Class{__includes = Scene}

function SceneStart:init()
  self.text = { 
    { string = GAME_TITLE, font = FONTS['zelda'], textColor = {175 / 255, 53 / 255, 42 / 255, 1}, shadowColor = {34 / 255, 34 / 255, 34 / 255, 1} },
    { string = 'Press Enter', font = FONTS['zelda-small'] }
  }
end

function SceneStart:update(dt)
  if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
    sceneManager:change('Play')
  end
end

function SceneStart:render()
  RenderCenteredText(self.text)
end
