Room = Class{}

function Room:init(player)
  self.size = MAP_SIZE
  self.tiles = {}
  self.entities = {}
  self.objects = {}
  self.player = player
  self.renderOffset = MAP_RENDER_OFFSET
  
  self:GenerateTileset()
end

function Room:update(dt)

end

function Room:render()
  for y = 1, self.size.y do
    for x = 1, self.size.x do
      local tile = self.tiles[y][x]
      love.graphics.draw(TEXTURES['tiles'], FRAMES['tiles'][tile.id],
        (x - 1) * TILE_SIZE + self.renderOffset.x,
        (y - 1) * TILE_SIZE + self.renderOffset.y)
    end
  end
end

function Room:GenerateTileset()
  for y = 1, self.size.y do
    table.insert(self.tiles, {})
    
    for x = 1, self.size.x do
      local id = TILE_FLOORS[math.random(#TILE_FLOORS)]
      
      table.insert(self.tiles[y], { id = id })
    end
  end
end