Entity = Class{}

function Entity:init(posX, posY, rotation, scaleX, scaleY)
  self.parent = nil
  
  -- transforms in local space
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
  
  if DEBUG_MODE and self.components['Collider'] then
    for k, collider in pairs(self.components['Collider']) do
      collider:render()
    end
  end
end

function Entity:AddComponent(component)
  component.entity = self
  -- overwrite components if their type only allows one instance per entity
  if component.componentType == 'AnimatorController' or
    component.componentType == 'Sprite' then
    self.components[component.componentType] = component
  elseif self.components[component.componentType] == nil or next(self.components[component.componentType]) == nil then
    self.components[component.componentType] = {}
    if component.name then
      self.components[component.componentType][component.name] = component
    else
      table.insert(self.components[component.componentType], component)
    end
  else
    self.components[component.componentType][component.name] = component
  end
  
  return component
end

function Entity:AddScript(scriptName)
  -- generates anonymous function that returns an instance of the script subclass
  local f = loadstring("return " .. scriptName .. "()")
  if f then
    local script = f()
    self:AddComponent(script)
    return script
  else
    error("Object '"..scriptName.."' does not exist or is not accessible.")
  end
end

-- Sets the parameter parent entity for this entity
-- If the entity parameter is nil, it unparents the entity
function Entity:SetParent(parent)
  
end