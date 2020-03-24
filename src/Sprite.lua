Sprite = Class{__includes = Component}

function Sprite:init(texture, quad)
  Component.init(self)
  self.componentType = 'Sprite'
  self.texture = texture
  -- if a quad is not given, create a new one with the whole texture
  self.quad = quad or love.graphics.newQuad(0, 0, texture:getWidth(), texture:getHeight(), 
    texture:getWidth(), texture:getHeight())
  self.flipX = false
  self.flipY = false
end

function Sprite:render()
  local x, y, w, h = self.quad:getViewport()
  x = math.floor(self.entity.position.x)
  y = math.floor(self.entity.position.y)
  local r = self.entity.rotation
  local sx = self.entity.scale.x
  local sy = self.entity.scale.y
  sx = sx * (self.flipX and -1 or 1)
  sy = sy * (self.flipY and -1 or 1)
  local ox = math.floor(w / 2)
  local oy = math.floor(h / 2)
  love.graphics.draw(self.texture, self.quad, x, y, r, sx, sy, ox, oy)
end
