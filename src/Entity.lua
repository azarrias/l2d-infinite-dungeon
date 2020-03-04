Entity = Class{}

function Entity:init(def)
  self.position = def.position
  self.texture = def.texture
  self.frame = def.frame
end

function Entity:render()
  if self.texture then
    love.graphics.draw(self.texture, self.frame, self.position.x, self.position.y)
  end
end