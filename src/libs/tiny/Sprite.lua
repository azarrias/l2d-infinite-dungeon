local current_folder = (...):gsub('%.Sprite$', '') -- "my package path"
local Component = require(current_folder .. '.Component')
local Vector2D = require(current_folder .. '.Vector2D')

local Sprite = Class{__includes = Component}

function Sprite:init(texture, quad)
  Component.init(self)
  self.componentType = 'Sprite'
  self:SetDrawable(texture, quad)
  self.flipX = false
  self.flipY = false
end

function Sprite:render()
  local p = self.entity.position:Floor()
  local r = self.entity.rotation
  local s = self.entity.scale
  s.x = s.x * (self.flipX and -1 or 1)
  s.y = s.y * (self.flipY and -1 or 1)
  love.graphics.draw(self.texture, self.quad, p.x, p.y, r, s.x, s.y, self.pivot.x, self.pivot.y)
end

function Sprite:SetDrawable(texture, quad)
  self.texture = texture
  -- if a quad is not given, create a new one with the whole texture
  self.quad = quad or love.graphics.newQuad(0, 0, texture:getWidth(), texture:getHeight(), 
    texture:getWidth(), texture:getHeight())
  
  -- set pivot at the center of the sprite
  local _, _, width, height = self.quad:getViewport()
  self.size = Vector2D(width, height)
  self.pivot = (self.size / 2):Floor()
end

return Sprite