local current_folder = (...):gsub('%.Sprite$', '') -- "my package path"
local Component = require(current_folder .. '.Component')
local Vector2D = require(current_folder .. '.Vector2D')

local Sprite = Class{__includes = Component}

function Sprite:init(texture, quad)
  Component.init(self)
  self.componentType = 'Sprite'
  if not texture then
    error("Can't find texture file")
  end
  self:SetDrawable(texture, quad)
  self.flipX = false
  self.flipY = false
  self.color = { 1, 1, 1, 1 }
end

function Sprite:render()
  local r, g, b, a = love.graphics.getColor()
  local oldColor = { r, g, b, a }
  love.graphics.setColor(self.color)
  
  local pos = self.entity.position:Floor()
  local rot = self.entity.rotation
  local sca = self.entity.scale
  sca.x = sca.x * (self.flipX and -1 or 1)
  sca.y = sca.y * (self.flipY and -1 or 1)
  love.graphics.draw(self.texture, self.quad, pos.x, pos.y, rot, sca.x, sca.y, self.pivot.x, self.pivot.y)
  
  love.graphics.setColor(oldColor)
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