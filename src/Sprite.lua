Sprite = Class{__includes = Component}

function Sprite:init(texture, quad)
  Component.init(self)
  self.componentType = 'Sprite'
  self.texture = texture
  self.quad = quad
  self.flipX = false
  self.flipY = false
end

function Sprite:render()
  if self.quad then
    local x, y, w, h = self.quad:getViewport()
    x = math.floor(self.parent.position.x)
    y = math.floor(self.parent.position.y)
    local r = self.parent.rotation
    local sx = self.parent.scale.x
    local sy = self.parent.scale.y
    sx = sx * (self.flipX and -1 or 1)
    sy = sy * (self.flipY and -1 or 1)
    local ox = math.floor(w / 2)
    local oy = math.floor(h / 2)
    love.graphics.draw(self.texture, self.quad, x, y, r, sx, sy, ox, oy)
  end
end
