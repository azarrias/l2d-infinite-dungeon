GameStateStart = Class{__includes = BaseState}

function GameStateStart:init()
  self.text = { 
    { string = GAME_TITLE, font = FONTS['zelda'], textColor = {175 / 255, 53 / 255, 42 / 255, 1}, shadowColor = {34 / 255, 34 / 255, 34 / 255, 1} },
    { string = 'Press Enter', font = FONTS['zelda-small'] }
  }
end

function GameStateStart:render()
  RenderCenteredText(self.text)
end
