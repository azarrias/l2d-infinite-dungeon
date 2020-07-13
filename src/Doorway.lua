Doorway = Class{}

function Doorway:init(direction, shift)
  self.direction = direction
  self.isOpen = false
  self.shift = shift or tiny.Vector2D(0, 0)
  
  local position
  if direction == 'left' then
    position = MAP_RENDER_OFFSET + self.shift + 
      tiny.Vector2D(-TILE_SIZE, MAP_SIZE.y / 2 * TILE_SIZE - TILE_SIZE)
  elseif direction == 'right' then
    position = MAP_RENDER_OFFSET + self.shift +
      tiny.Vector2D(MAP_SIZE.x * TILE_SIZE - TILE_SIZE, MAP_SIZE.y / 2 * TILE_SIZE - TILE_SIZE)
  elseif direction == 'top' then
    position = MAP_RENDER_OFFSET + self.shift + 
      tiny.Vector2D(MAP_SIZE.x / 2 * TILE_SIZE - TILE_SIZE, -TILE_SIZE)
  elseif direction == 'bottom' then
    position = MAP_RENDER_OFFSET + self.shift +
      tiny.Vector2D(MAP_SIZE.x / 2 * TILE_SIZE - TILE_SIZE, MAP_SIZE.y * TILE_SIZE - TILE_SIZE)
  end
  
  self.gameObject = tiny.Entity(position.x, position.y)
end

function Doorway:render()
  local state_str = self.isOpen and 'open' or 'closed'
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][1],
    self.gameObject.position.x, self.gameObject.position.y)
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][2],
    self.gameObject.position.x + TILE_SIZE, self.gameObject.position.y)
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][3],
    self.gameObject.position.x, self.gameObject.position.y + TILE_SIZE)
  love.graphics.draw(TEXTURES['tiles'], FRAMES['door-' .. state_str .. '-' .. self.direction][4],
    self.gameObject.position.x + TILE_SIZE, self.gameObject.position.y + TILE_SIZE)
  self.gameObject:render()
end
