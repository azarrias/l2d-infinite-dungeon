AnimationFrame = Class{}

function AnimationFrame:init(texture, quad, duration)
  self.texture = texture
  self.quad = quad or love.graphics.newQuad(0, 0, texture:getWidth(), texture:getHeight(), 
    texture:getWidth(), texture:getHeight())
  self.duration = duration or 1
end
