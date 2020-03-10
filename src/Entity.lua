Entity = Class{}

function Entity:init(def)
  self.position = def.position
  self.texture = def.texture
  self.frame = def.frame
  self.components = {}
end

function Entity:render()
  if self.texture then
    love.graphics.draw(self.texture, self.frame, self.position.x, self.position.y)
  end
end

function Entity:AddComponent(component)
  component.parent = self
  if component.componentType == 'AnimatorController' then
    self.components[component.componentType] = component
  end
end
