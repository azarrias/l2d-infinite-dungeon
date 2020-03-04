GameStatePlay = Class{__includes = BaseState}

function GameStatePlay:init()
  self.player = Entity {
    position = Vector2D(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2),
    texture = TEXTURES['player'],
    frame = FRAMES['player-walk-down'][1]
  }
end

function GameStatePlay:render()
  self.player:render()
end