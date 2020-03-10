Entity = Class{}

function Entity:init(def)
  self.position = def.position
  self.size = def.size
  self.texture = def.texture
  self.frame = def.frame
  self.components = {}
end

function Entity:render()
  if self.components['AnimatorController'] then
    self.components['AnimatorController'].stateMachine.currentState.animation:draw(
      self.texture, 
      -- shift the character half its width and height, since the origin must be at the sprite's center
      math.floor(self.position.x) + self.size.x / 2,-- + self.pivotPoint.x, 
      math.floor(self.position.y) + self.size.y / 2,-- + self.pivotPoint.y,
--      0, self.orientation == 'right' and 1 or -1, 1,
      0, 1, 1, 
      -- set origin to the sprite center (to allow reversing it through negative scaling)
      --self.pivotPoint.x, self.pivotPoint.y
      self.size.x / 2, self.size.y / 2
    )
  elseif self.texture then
    love.graphics.draw(self.texture, self.frame, self.position.x, self.position.y)
  end
end

function Entity:AddComponent(component)
  component.parent = self
  if component.componentType == 'AnimatorController' then
    self.components[component.componentType] = component
  end
end
