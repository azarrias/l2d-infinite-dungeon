Collider = Class{__includes = Component}

function Collider:init(def)
  Component.init(self)
  self.componentType = 'Collider'
  
  -- center and size in the collider's local space
  self.center = def.center
  self.size = def.size
end

function Collider:update(dt)
end

function Collider:render()
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(1, 0.6, 0.6, 0.7)
  love.graphics.rectangle(
    'fill', 
    math.floor(self.parent.position.x + self.center.x - self.size.x / 2), 
    math.floor(self.parent.position.y + self.center.y - self.size.y / 2), 
    self.size.x, 
    self.size.y
  )
  love.graphics.setColor(r, g, b, a)
end

function Collider:checkTileCollisions(dt, tilemap, direction)
  local tile
  
  if direction == 'left-top' then
    tile = tilemap:pointToTile(Vector2D(self.parent.position.x + self.center.x - self.size.x / 2, 
                                        self.parent.position.y + self.center.y - self.size.y / 2))
  elseif direction == 'right-top' then
    tile = tilemap:pointToTile(Vector2D(self.parent.position.x + self.center.x + self.size.x / 2, 
                                        self.parent.position.y + self.center.y - self.size.y / 2))
  elseif direction == 'left-bottom' then
    tile = tilemap:pointToTile(Vector2D(self.parent.position.x + self.center.x - self.size.x / 2, 
                                        self.parent.position.y + self.center.y + self.size.y / 2))
  elseif direction == 'right-bottom' then
    tile = tilemap:pointToTile(Vector2D(self.parent.position.x + self.center.x + self.size.x / 2, 
                                        self.parent.position.y + self.center.y + self.size.y / 2))
  end
  
  if tile and tile:collidable() then
    return tile
  else
    return nil
  end
end

function Collider:checkObjectCollisions()
  for k, object in pairs(self.parent.level.objects) do
    if next(object.colliders) ~= nil and object.colliders['collider'] ~= nil and self:collides(object.colliders['collider']) then
      if object.consumable then
        object.onConsume(self.parent)
        table.remove(self.parent.level.objects, k)
      elseif object.trigger then
        object.onTrigger(self.parent, k)
      else
        return object
      end
    end
  end
  
  return nil
end

function Collider:checkEntityCollisions()
  for k, entity in pairs(self.parent.level.entities) do
    if entity.colliders['collider'] and self:collides(entity.colliders['collider']) then
--      return table.remove(self.parent.level.entities, k)
      return k
    end
  end
  
  return nil
end

function Collider:collides(other)
  -- AABB collision detection
  if other.parent.position.x + other.center.x - other.size.x / 2 > self.parent.position.x + self.center.x + self.size.x / 2 then
    return false
  elseif self.parent.position.x + self.center.x - self.size.x / 2 > other.parent.position.x + other.center.x + other.size.x / 2 then
    return false
  elseif other.parent.position.y + other.center.y - other.size.y / 2 > self.parent.position.y + self.center.y + self.size.y / 2 then
    return false
  elseif self.parent.position.y + self.center.y - self.size.y / 2 > other.parent.position.y + other.center.y + other.size.y / 2 then
    return false
  else
    return true
  end
end