Doorway = Class{}

function Doorway:init(direction, isOpen)
  self.direction = direction
  self.isOpen = isOpen
  
  if direction == 'left' then
    self.position = MAP_RENDER_OFFSET + 
      tiny.Vector2D(-TILE_SIZE, MAP_SIZE.y / 2 * TILE_SIZE - TILE_SIZE)
  elseif direction == 'right' then
    self.position = MAP_RENDER_OFFSET + 
      tiny.Vector2D(MAP_SIZE.x * TILE_SIZE - TILE_SIZE, MAP_SIZE.y / 2 * TILE_SIZE - TILE_SIZE)
  elseif direction == 'top' then
    self.position = MAP_RENDER_OFFSET + 
      tiny.Vector2D(MAP_SIZE.x / 2 * TILE_SIZE - TILE_SIZE, -TILE_SIZE)
  elseif direction == 'bottom' then
    self.position = MAP_RENDER_OFFSET + 
      tiny.Vector2D(MAP_SIZE.x / 2 * TILE_SIZE - TILE_SIZE, MAP_SIZE.y * TILE_SIZE - TILE_SIZE)
  end
end

function Doorway:render()
  local state_str = self.isOpen and 'open' or 'closed'
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][1],
    self.position.x, self.position.y)
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][2],
    self.position.x + TILE_SIZE, self.position.y)
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][3],
    self.position.x, self.position.y + TILE_SIZE)
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][4],
    self.position.x + TILE_SIZE, self.position.y + TILE_SIZE)
end
