Entity = Class{}

function Entity:init(posX, posY, rotation, scaleX, scaleY)
  self.position = Vector2D(posX, posY)
  self.rotation = rotation or 0
  self.scale = scaleX and scaleY and Vector2D(scaleX, scaleY) or Vector2D(1, 1)
  self.components = {}
end

function Entity:update(dt)
  for k, componentType in pairs(self.components) do
    if k == 'AnimatorController' or k == 'Sprite' then
      componentType:update(dt)
    else
      for i, component in pairs(componentType) do
        component:update(dt)
      end
    end
  end
end

function Entity:render()
  if self.components['Sprite'] then
    self.components['Sprite']:render()
  end
--[[
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
]]
end

function Entity:AddComponent(component)
  component.parent = self
  -- overwrite components if their type only allows one instance per entity
  if component.componentType == 'AnimatorController' or
    component.componentType == 'Sprite' then
    self.components[component.componentType] = component
  elseif self.components[component.componentType] == nil or next(self.components[component.componentType]) == nil then
    self.components[component.componentType] = {}
    self.components[component.componentType][component.name] = component
  else
    self.components[component.componentType][component.name] = component
  end
end

function Entity:AddScript(scriptName)
  -- generates anonymous function that returns an instance of the script subclass
  local f = loadstring("return " .. scriptName .. "()")
  if f then
    local script = f()
    self:AddComponent(script)
  else
    error("Object '"..scriptName.."' does not exist or is not accessible.")
  end
end

function AnimatorState:AddStateMachineBehaviour(behaviourName)
  -- generates anonymous function that returns an instance of the behaviour class
  local f = loadstring("return " .. behaviourName .. "()")
  if f then
    local behaviour = f()
    self.behaviours[behaviourName] = behaviour
  else
    error("Object '"..behaviourName.."' does not exist or is not accessible.")
  end
end