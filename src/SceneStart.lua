SceneStart = Class{__includes = tiny.Scene}

function SceneStart:init()
  self.text = { 
    { string = GAME_TITLE, font = FONTS['zelda'], textColor = {175 / 255, 53 / 255, 42 / 255, 1}, shadowColor = {34 / 255, 34 / 255, 34 / 255, 1} },
    { string = 'Press Enter', font = FONTS['zelda-small'] }
  }
  local background = TEXTURES['background']
  local sprite = tiny.Sprite(background)
  self.backgroundGameObject = tiny.Entity(VIRTUAL_SIZE.x / 2, VIRTUAL_SIZE.y / 2, 0, 
    VIRTUAL_SIZE.x / background:getWidth(), VIRTUAL_SIZE.y / background:getHeight())
  self.backgroundGameObject:AddComponent(sprite)
end

function SceneStart:update(dt)
  if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
    sceneManager:change('Play')
  end
end

function SceneStart:render()
  self.backgroundGameObject:render()
  RenderCenteredText(self.text)
end
