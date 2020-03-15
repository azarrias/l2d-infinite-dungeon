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
      local id = TILE_EMPTY
      
      if x == 1 and y == 1 then
        id = TILE_TOP_LEFT_CORNER
      elseif x == 1 and y == self.size.y then
        id = TILE_BOTTOM_LEFT_CORNER
      elseif x == self.size.x and y == 1 then
        id = TILE_TOP_RIGHT_CORNER
      elseif x == self.size.x and y == self.size.y then
        id = TILE_BOTTOM_RIGHT_CORNER
      elseif x == 1 then
        id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
      elseif x == self.size.x then
        id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
      elseif y == 1 then
        id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
      elseif y == self.size.y then
        id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
      else
        id = TILE_FLOORS[math.random(#TILE_FLOORS)]
      end
      
      table.insert(self.tiles[y], { id = id })
    end
  end
end